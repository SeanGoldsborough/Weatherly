//
//  MainView.swift
//  Weatherly
//
//  Created by Sean Goldsborough on 9/23/24.
//

import SwiftUI
import CoreData

struct RecentSearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var coordinator: Coordinator
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>
    @State private var showAlert = false
    
    var body: some View {
        List {
                ForEach(items) { item in
                    ZStack {
                        VStack {
                            HStack {
                                VStack {
                                Spacer()
                                    HStack {
                                        Text(item.cityName ?? "")
                                            .padding(0)
                                            .multilineTextAlignment(.leading)
                                    }
                                    if let icon = item.icon {
                                        AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")) { image in
                                            image.resizable()
                                            
                                        } placeholder: {
                                            Image(systemName: "sun.max.fill")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .foregroundColor(.yellow)
                                                .padding(.bottom, 40)
                                        }
                                        .frame(width: 30, height: 30)
                                        .border(.black)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        if let desc = item.desc {
                                            Text(desc.capitalized)
                                                .font(.caption2)
                                        }
                                    }
                                }
                                Spacer()
                                VStack {
                                    Spacer()
                                    HStack {
                                        Text("Current Temp:")
                                            .font(.caption2)
                                    }
                                    HStack {
                                        Text("\(item.temp)")
                                            .font(.title)
                                    }
                                    HStack {
                                        //Spacer()
                                        Text("H: \(item.maxTemp)  L:58 \(item.minTemp)")
                                            .font(.caption2)
                                    }.padding(.bottom, 20)
                                }
                            }
                        }
                    }
                    .background(Color.white)
                    .onTapGesture {
                        coordinator.push(page: .main)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .padding(.top, 10)
            .navigationTitle("Weatherly")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .alert("Network Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {showAlert = false}
            } message: {
                Text("Unable to create a network connection. Please try again.")
            }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                showAlert = true
            }
        }
    }
}
