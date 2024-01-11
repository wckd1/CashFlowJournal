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
    var title: String
    var amount: Float
    @Transient var type: TransactionType {
        get { TransactionType(rawValue: _type)! }
        set { _type = newValue.rawValue }
    }
    @Attribute private var _type: TransactionType.RawValue
    var source: Source?
    var category: Category?
    private(set) var account: Account?
    let date: Date
    
    init(title: String, amount: Float, type: TransactionType, source: Source? = nil, category: Category? = nil, account: Account, date: Date = Date()) {
        self.title = title
        self.amount = amount
        self._type = type.rawValue
        self.source = source
        self.category = category
        self.account = account
        self.date = date
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

struct TransactionGroup: Identifiable {
    var id: String
    let transactions: [Transaction]
}

extension Array where Element: Transaction {
    func groups() -> [TransactionGroup] {
        Dictionary(
            grouping: self,
            by: { $0.date.formatted(date: .long, time: .omitted) }
        ).map {
            TransactionGroup(
                id: $0.key,
                transactions: $0.value
                .sorted(by: {  $0.date > $1.date })
            )
        }
        .sorted(by: {
            $0.transactions.first!.date > $1.transactions.first!.date
        })
    }
    
    func filter(period: PeriodFilter) -> [Transaction] {
        guard let interval = period.periodDates() else { return self }
        return self.filter { transaction in
            transaction.date >= interval.start
            && transaction.date <= interval.end
        }
    }
}
