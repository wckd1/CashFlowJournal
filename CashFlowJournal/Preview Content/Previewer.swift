//
//  Previewer.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 29.12.2023.
//

import Foundation
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let accounts: [Account]
    let transactions: [Transaction]
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Account.self, configurations: config)
        
        accounts = [
            Account(name: "Cash", balance: 10),
            Account(name: "Lovcen", balance: 1450)
        ]

        for account in accounts {
            container.mainContext.insert(account)
        }
        
        transactions = [
            Transaction(title: "Groceries", amount: 45.64, source: nil, category: "Food", account: accounts[1]),
            Transaction(title: "Salary", amount: 450.00, source: "Salary", category: nil, account: accounts[1]),
            Transaction(title: "Snack", amount: 12.50, source: nil, category: "Snack", account: accounts[0])
        ]
        
        for transaction in transactions {
            container.mainContext.insert(transaction)
        }
    }
}
