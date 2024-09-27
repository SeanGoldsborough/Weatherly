//
//  CoordinatorView.swift
//  Weatherly
//
//  Created by Sean Goldsborough on 9/23/24.
//

import SwiftUI
import CoreLocation

struct CoordinatorView: View {
    
    @StateObject private var coordinator = Coordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .main)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
        .onAppear{
            Task {
                do {
                    let _ = try await ViewModel()
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    CoordinatorView()
}
