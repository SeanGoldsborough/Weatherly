//
//  WeatherlyApp.swift
//  Weatherly
//
//  Created by Sean Goldsborough on 9/23/24.
//

import SwiftUI

@main
struct WeatherlyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
        }
    }
}
