//
//  AppScreenCases.swift
//  Weatherly
//
//  Created by Sean Goldsborough on 9/23/24.
//

import Foundation

enum AppPages: Hashable {
    case recentSearch
    case main
}

enum Sheet: String, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case tempDetail
}

enum FullScreenCover: String, Identifiable {
    var id: String {
        self.rawValue
    }
    
    case overlay
}
