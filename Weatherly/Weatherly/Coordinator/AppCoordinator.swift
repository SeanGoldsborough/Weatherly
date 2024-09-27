//
//  AppCoordinator.swift
//  Weatherly
//
//  Created by Sean Goldsborough on 9/23/24.
//

import Foundation
import SwiftUI


class Coordinator: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    
    func push(page: AppPages) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    @ViewBuilder
    func build(page: AppPages) -> some View {
        switch page {
        case .recentSearch: RecentSearchView()
        case .main: MainView()
        }
    }
}

