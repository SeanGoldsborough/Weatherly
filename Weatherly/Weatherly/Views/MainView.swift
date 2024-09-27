//
//  LoginView.swift
//  Weatherly
//
//  Created by Sean Goldsborough on 9/23/24.
//

import SwiftUI
import Combine
import AVFoundation
import CoreData

struct MainView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @EnvironmentObject private var coordinator: Coordinator
    @State private var cityName: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var isRecording = false
    
    @StateObject private var viewModel = ViewModel()
    @State var showAlert = false
    @StateObject var locationManager = LocationManager.shared
    @StateObject var speechRecognizer = SpeechRecognizer()
    
    private var player: AVPlayer { AVPlayer.sharedDingPlayer }
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Weatherly")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.bottom, 20)
            
            AsyncImage(url: URL(string: viewModel.imageURL)) { image in
                image.resizable()
                
            } placeholder: {
                Image(systemName: "sun.max.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.yellow)
                    .padding(.bottom, 40)
            }
            .frame(width: 128, height: 128)
            .border(viewModel.imageURL.isEmpty ? .clear : .black)
            
            VStack(alignment: .center) {
                if !viewModel.cityName.isEmpty {
                    Text(viewModel.cityName)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    Text(viewModel.temp)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    Text("Feels Like: \(viewModel.feelsLike)")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    HStack {
                        Text("L: \(viewModel.minTemp)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        Text(" - ")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        Text("H: \(viewModel.maxTemp)")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                    }
                    HStack {
                        Text(viewModel.description.capitalized)
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                    }
                }
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for a city", text: $cityName)
                        .onSubmit {
                            Task {
                                do {
                                    try await viewModel.getWeatherData(locationName: cityName)
                                } catch {
                                    showAlert = viewModel.showAlert
                                }
                            }
                        }
                    
                    Button(action: {
                        isRecording.toggle()
                        if isRecording {
                            speechRecognizer.resetTranscript()
                            speechRecognizer.startTranscribing()
                        } else {
                            speechRecognizer.stopTranscribing()
                            cityName = speechRecognizer.transcript
                        }
                    }) {
                        Image(systemName: isRecording ? "mic.fill" : "mic")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(5)
            }
            .padding(.horizontal, 30)
            
            Button(action: {
                Task {
                    do {
                        try await viewModel.getWeatherData(locationName: cityName)
                        let data = try await viewModel.getData(locationName: cityName)
                        addItem(data: data)
                    } catch {
                        showAlert = true
                    }
                }
            }) {
                Text("SEARCH")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(cityName.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
            }
            .padding(.top, 30)
            .disabled(cityName.isEmpty)
            
            Spacer()
            
            VStack {
                Button(action: {
                    coordinator.push(page: .recentSearch)
                    
                }) {
                    Text("Recent Searches")
                        .foregroundColor(.blue)
                }
                .padding(.bottom, 40)
                .accessibilityIdentifier("RecentSearchButton")
            }
        }.background(Color(.black))
            .background(Color(.systemGroupedBackground))
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                if items.count <= 0 {
                    viewModel.getMyLocation()
                    if let latitude = locationManager.locationManager.location?.coordinate.latitude,
                       let longitude = locationManager.locationManager.location?.coordinate.longitude {
                        Task {
                            do {
                                let data = try await viewModel.getDataWithLongLat(long: "\(longitude)", lat: "\(latitude)")
                                addItem(data: data)
                            } catch {
                                showAlert = true
                            }
                        }
                    }
                    
                } else {
                    fetchLastSearch()
                }
            }
            .alert("Invalid Search", isPresented: $showAlert) {
                Button("OK", role: .cancel) {showAlert = false}
            } message: {
                Text("Please check your entry and try again.")
            }
        
    }
    
    func fetchLastSearch() {
        if let item = items.last, let name = item.cityName, let description = item.desc, let icon = item.icon {
            DispatchQueue.main.async {
                viewModel.cityName = name
                viewModel.temp = "\(item.temp)"
                viewModel.feelsLike = "\(item.feelsLike)"
                viewModel.description = description
                viewModel.icon = icon
                viewModel.minTemp = "\(item.minTemp)"
                viewModel.maxTemp = "\(item.maxTemp)"
                viewModel.imageURL = "https://openweathermap.org/img/wn/\(icon)@2x.png"
            }
        }
    }
    
    func addItem(data: Base) {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            if let name = data.name, let temp = data.main?.temp, let feelsLike = data.main?.feels_like, let description = data.weather?.first?.description,
               let icon = data.weather?.first?.icon, let minTemp = data.main?.temp_min, let maxTemp = data.main?.temp_max {
                newItem.cityName = name
                newItem.temp = temp
                newItem.feelsLike = feelsLike
                newItem.desc = description
                newItem.icon = icon
                newItem.minTemp = minTemp
                newItem.maxTemp = maxTemp
                newItem.imageURL = "https://openweathermap.org/img/wn/\(icon)@2x.png"
            }
            
            do {
                try viewContext.save()
            } catch {
                DispatchQueue.main.async {
                    self.showAlert = true
                }
            }
        }
    }
}

