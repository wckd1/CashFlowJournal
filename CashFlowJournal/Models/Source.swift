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
    @Attribute(.unique) var name: String
    var color: String
    var icon: String
    @Relationship(inverse: \Transaction.source) var transactions: [Transaction] = [Transaction]()
    var group: SourceGroup?
    
    init(name: String, color: String, icon: String, group: SourceGroup? = nil) {
        self.name = name
        self.color = color
        self.icon = icon
        self.group = group
    }
}
