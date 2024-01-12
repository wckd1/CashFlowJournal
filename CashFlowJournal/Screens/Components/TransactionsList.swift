//
//  TransactionsList.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 10.01.2024.
//

import SwiftUI

struct TransactionsList: View {
    let transactions: [Transaction]
    private var sortedTransactions: [TransactionGroup] {
        transactions.groups()
    }
    
    var body: some View {
        if transactions.count < 1 {
            ContentUnavailableView(
                String(localized: "no_transactions_title"),
                systemImage: "clipboard",
                description: Text("no_transactions_description")
            )
        } else {
            List {
                ForEach(sortedTransactions) { group in
                    Section {
                        ForEach(group.transactions) { transaction in
                            NavigationLink {
                                TransactionDetailsView(transaction: transaction)
                            } label: {
                                TransactionCell(transaction: transaction)
                            }
                        }
                    } header: {
                        Text(group.id)
                            .modifier(UrbanistFont(.regular, size: 18))
                            .foregroundColor(Color.gray)
                    }
                }
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                .listRowBackground(Color.bg_color)
            }
            .listStyle(.plain)
            .listSectionSpacing(.compact)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            TransactionsList(transactions: previewer.transactions)
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
