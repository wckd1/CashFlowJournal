//
//  Source.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 03.01.2024.
//

import SwiftData
import Foundation

@Model
class Source {
    var id: UUID
    @Attribute(.unique) var name: String
    var color: String
    var icon: String
    
    init(name: String, color: String, icon: String) {
        self.id = UUID()
        self.name = name
        self.color = color
        self.icon = icon
    }
}
