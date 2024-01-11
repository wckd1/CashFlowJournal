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
            Account(name: "Cash", balance: 359, color: Color.random().toHex()),
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
        var trxBuild: [Transaction] = []
        for dayOffset in 1...30 {
            let count = Int.random(in: 1..<10)
            
            for index in (0...count) {
                let sourceIndex = Int.random(in: 0..<sources.count)
                let categoryIndex = Int.random(in: 0..<categories.count)
                
                let typeRand = Int.random(in: 1..<10)
                let ttype: TransactionType = typeRand < 6 ? .income : .expense
                
                let trx = Transaction(
                    title: "Transaction_\(dayOffset)_\(index)",
                    amount: Float.random(in: 20..<100),
                    type: ttype,
                    source: ttype == .income ? sources[sourceIndex] : nil,
                    category: ttype == .expense ? categories[categoryIndex] : nil,
                    account: nil,
                    originAccount: accounts[1],
                    date: Calendar.current.date(byAdding: .day, value: -dayOffset, to: Date())!
                )
                
                trxBuild.append(trx)
                container.mainContext.insert(trx)
            }
        }
        
        
        transactions = trxBuild
    }
}
