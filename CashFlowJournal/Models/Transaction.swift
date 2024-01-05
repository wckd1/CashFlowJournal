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
    @Transient var type: TransactionType {
        get { TransactionType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    @Attribute var _type: TransactionType.RawValue
    var source: Source?
    var category: Category?
    var account: Account
    let date: Date
    
    init(title: String, amount: Float, type: TransactionType, source: Source? = nil, category: Category? = nil, account: Account) {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self._type = type.rawValue
        self.source = source
        self.category = category
        self.account = account
        self.date = Date()
    }
}

enum TransactionType: String, Codable, CaseIterable {
    case income
    case expense
    
    var title: String {
        switch self {
        case .income: return String(localized: "income")
        case .expense: return String(localized: "expense")
        }
    }
}
