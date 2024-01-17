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
                    DashboardBalanceView()
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
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("dashboard_greeting \(username)")
                        .modifier(UrbanistFont(.regular, size: 18))
                        .foregroundColor(Color.text_color)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        TransactionAddView()
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.white)
                            .background(Color.primary_color.gradient, in: .circle)
                            .contentShape(.circle)
                    }
                }
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
