//
//  Category.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 04.01.2024.
//

import SwiftData
import Foundation

@Model
class Category {
    @Attribute(.unique) var name: String
    var color: String
    var icon: String
    @Relationship(inverse: \Transaction.category) var transactions: [Transaction] = [Transaction]()
    @Relationship var group: CategoryGroup?
     
    init(name: String, color: String, icon: String, group: CategoryGroup? = nil) {
        self.name = name
        self.color = color
        self.icon = icon
        self.group = group
    }
}
