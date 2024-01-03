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
    var source: String?
    var category: String?
    var account: Account
    let date: Date
    
    init(title: String, amount: Float, source: String?, category: String?, account: Account) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.source = source
        self.category = category
        self.account = account
        self.date = Date()
    }
}
