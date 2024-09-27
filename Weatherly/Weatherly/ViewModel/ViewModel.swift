//
//  ViewModel.swift
//  Weatherly
//
//  Created by Sean Goldsborough on 9/23/24.
//

import Foundation
import SwiftUI
import CoreData

public class ViewModel: ObservableObject {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @Published var locationManager = LocationManager.shared
    
    var APIKey = "4726810c4553511766f7806b8a69ff93" // would move this to separate file for .gitignore
    @Published var cityName = ""
    @Published var temp = ""
    @Published var feelsLike = ""
    @Published var description = ""
    @Published var icon = ""
    @Published var minTemp = ""
    @Published var maxTemp = ""
    @Published var imageURL = ""
    @State var showAlert = false
    
    init() { }
    
    func getWeatherData(locationName: String) async {
        Task {
            do {
                let data = try await getData(locationName: locationName)
                DispatchQueue.main.async {
                    if let name = data.name, let temp = data.main?.temp, let feelsLike = data.main?.feels_like, let description = data.weather?.first?.description,
                       let icon = data.weather?.first?.icon, let minTemp = data.main?.temp_min, let maxTemp = data.main?.temp_max {
                        DispatchQueue.main.async {
                            self.cityName = name
                            self.temp = "\(temp)"
                            self.feelsLike = "\(feelsLike)"
                            self.description = description
                            self.icon = icon
                            self.minTemp = "\(minTemp)"
                            self.maxTemp = "\(maxTemp)"
                            self.imageURL = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert = true
                }
            }
        }
    }
    
    func getData(locationName: String) async throws -> Base {
        var pre = Locale.preferredLanguages[0]
        var adjustedLang = pre.dropLast(3)
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(locationName)&appid=\(APIKey)&lang=\(adjustedLang)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(Base.self, from: data)
        
        self.cityName = decoded.name ?? "N/A"
        return decoded
    }
    
    func getDataWithLongLat(long: String, lat: String) async throws -> Base {
        var pre = Locale.preferredLanguages[0]
        var adjustedLang = pre.dropLast(3)
        
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=\(APIKey)&lang=\(adjustedLang)")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(Base.self, from: data)
        
        self.cityName = decoded.name ?? "N/A"
        return decoded
    }
    
    func getMyLocation() {
        if let latitude = locationManager.locationManager.location?.coordinate.latitude,
           let longitude = locationManager.locationManager.location?.coordinate.longitude {
            Task {
                do {
                    let data = try await getDataWithLongLat(long: "\(longitude)", lat: "\(latitude)")
                    DispatchQueue.main.async {
                        if let name = data.name, let temp = data.main?.temp, let feelsLike = data.main?.feels_like, let description = data.weather?.first?.description,
                           let icon = data.weather?.first?.icon, let minTemp = data.main?.temp_min, let maxTemp = data.main?.temp_max {
                            DispatchQueue.main.async {
                                self.cityName = name
                                self.temp = "\(temp)"
                                self.feelsLike = "\(feelsLike)"
                                self.description = description
                                self.icon = icon
                                self.minTemp = "\(minTemp)"
                                self.maxTemp = "\(maxTemp)"
                                self.imageURL = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                            }
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.showAlert = true
                    }
                }
            }
        }
    }
}
