//
//  Account.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 29.12.2023.
//

import SwiftData
import Foundation

@Model
class Account {
    var id: UUID
    var name: String = ""
    var balance: Float = 0.0
    var color: String
    var transactions: [Transaction]? = [Transaction]()
    
    init(name: String, balance: Float = 0, color: String) {
        self.id = UUID()
        self.name = name
        self.balance = balance
        self.color = color
    }
}
