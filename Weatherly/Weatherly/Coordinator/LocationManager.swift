//
//  LocationManager.swift
//  Weatherly
//
//  Created by Sean Goldsborough on 9/26/24.
//

import Foundation
import SwiftUI
import CoreLocation

public class LocationManager: ObservableObject {
    public static let shared = LocationManager()
    init() { 
        locationManager.requestWhenInUseAuthorization()
    }
        
    let locationManager = CLLocationManager()
    @Published var status: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
}
