//
//  Transaction.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 29.12.2023.
//

import SwiftData
import Foundation

@Model
class Transaction {
    var id: UUID
    var title: String
    var amount: Float
    var type: TransactionType
    var account: Account
    let date: Date
    
    init(title: String, amount: Float, type: TransactionType, account: Account) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.type = type
        self.account = account
        self.date = Date()
    }
}

enum TransactionType: Codable {
    case income(source: UUID)
    case expense(category: String)
}
