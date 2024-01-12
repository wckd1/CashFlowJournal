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
    var name: String = ""
    var balance: Float = 0.0
    var color: String
    @Relationship(inverse: \Transaction.account) var transactions: [Transaction] = [Transaction]()
    @Relationship var group: AccountGroup?
    
    init(name: String, balance: Float = 0, color: String, group: AccountGroup? = nil) {
        self.name = name
        self.balance = balance
        self.color = color
        self.group = group
    }
}
