//
//  DashboardView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 29.12.2023.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) var modelContext
    
    @AppStorage(UserDefaults.usernameKey)
    private var username: String = UserDefaults.username
    
    
    @Query private var transactions: [Transaction]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bg_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Balance
                    BalanceView()
                    
                    // Transactions
                    if transactions.count > 1 {
                        // Transactions
                        Text("dashboard_transactions_title")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .modifier(UrbanistFont(.regular, size: 24))
                            .foregroundColor(Color.text_color)
                            .padding(.bottom, 12)
                        
                        List {
                            ForEach(transactions) { transaction in
                                TransactionCell(transaction: transaction)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                            .listRowBackground(Color.bg_color)
                        }
                        .listStyle(.plain)
                    } else {
                        ContentUnavailableView(
                            String(localized: "dashboard_no_transactions_title"),
                            systemImage: "clipboard",
                            description: Text("dashboard_no_transactions_description")
                        )
                    }
                }
                .padding(12)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("dashboard_greeting \(username)")
                        .modifier(UrbanistFont(.regular, size: 18))
                        .foregroundColor(Color.text_color)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("dashboard_add_menu", systemImage: "plus") {
                        Button {} label: {
                            Text("add_transaction")
                        }
                        .buttonStyle(.plain)
                        NavigationLink(destination: AddIncomeSourceView()) {
                            Text("add_source")
                        }
                        .buttonStyle(.plain)
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
