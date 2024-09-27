//
//  Transcript.swift
//  Weatherly
//
//  Created by Sean Goldsborough on 9/26/24.
//

import Foundation

struct Transcript: Identifiable, Codable {
    let id: UUID
    let date: Date
    var transcript: String?
    
    init(id: UUID = UUID(), date: Date = Date(), transcript: String? = nil) {
        self.id = id
        self.date = date
        self.transcript = transcript
    }
}
