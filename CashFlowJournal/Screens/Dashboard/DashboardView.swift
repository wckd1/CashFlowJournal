//
//  DashboardView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 29.12.2023.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @AppStorage(UserDefaults.usernameKey)
    private var username: String = ""
    
    @Query private var transactions: [Transaction]
    private var sortedTransactions: [TransactionGroup] {
        transactions.groups()
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.bg_color.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Balance
                    BalanceView()
                        .padding(.horizontal, 12)
                    
                    // Transactions
                    if transactions.count < 1 {
                        ContentUnavailableView(
                            String(localized: "dashboard_no_transactions_title"),
                            systemImage: "clipboard",
                            description: Text("dashboard_no_transactions_description")
                        )
                    } else {
                        TransactionsList(transactions: transactions)
                    }
                }
                .padding(.vertical, 12)
                
                NavigationLink(destination: TransactionAddView()) {
                    Text("add_transaction")
                        .foregroundStyle(Color.text_color)
                }
                .buttonStyle(.plain)
                .padding(.vertical, 12)
                .padding(.horizontal, 18)
                .background(Color.primary_color)
                .cornerRadius(6)
                .padding(.trailing, 18)
                .padding(.bottom, 12)
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return DashboardView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
