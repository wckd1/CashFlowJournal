//
//  Previewer.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 29.12.2023.
//

import SwiftUI
import SwiftData

@MainActor
struct Previewer {
    let container: ModelContainer
    let accounts: [Account]
    let sources: [Source]
    let categories: [Category]
    let transactions: [Transaction]
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Account.self, Transaction.self, Source.self, Category.self, configurations: config)
        
        // Accounts
        accounts = [
            Account(name: "Cash", balance: 10, color: Color.random().toHex()),
            Account(name: "Lovcen", balance: 1450, color: Color.random().toHex())
        ]

        for account in accounts {
            container.mainContext.insert(account)
        }
        
        // Income sources
        sources = [
            Source(name: "Salary", color: Color.random().toHex(), icon: "dollarsign"),
            Source(name: "Freelance", color: Color.random().toHex(), icon: "arrowshape.up"),
            Source(name: "Gift", color: Color.random().toHex(), icon: "gift"),
        ]
        
        for source in sources {
            container.mainContext.insert(source)
        }
        
        // Expense categories
        categories = [
            Category(name: "Food", color: Color.random().toHex(), icon: "bag"),
            Category(name: "Rent", color: Color.random().toHex(), icon: "house")
        ]
        
        for category in categories {
            container.mainContext.insert(category)
        }
        
        // Transactions
        transactions = [
            Transaction(title: "Groceries", amount: 12.50, type: .expense, category: categories[0], account: accounts[0]),
            Transaction(title: "Salary", amount: 450.00, type: .income, source: sources[0], account: accounts[1]),
            Transaction(title: "December rent", amount: 45.64, type: .expense, category: categories[1], account: accounts[1])
        ]
        
        for transaction in transactions {
            container.mainContext.insert(transaction)
        }
    }
}
