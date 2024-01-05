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
    
    @Query(sort: \Transaction.date, order: .reverse)
    private var transactions: [Transaction]
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                Color.bg_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Balance
                    BalanceView()
                        .padding(.horizontal, 12)
                    
                    // Transactions
                    if transactions.count > 1 {
                        // Transactions
                        Text("dashboard_transactions_title")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .modifier(UrbanistFont(.regular, size: 24))
                            .foregroundColor(Color.text_color)
                            .padding(.bottom, 12)
                            .padding(.horizontal, 12)
                        
                        List {
                            ForEach(transactions) { transaction in
                                TransactionCell(transaction: transaction)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
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
                .padding(.vertical, 12)
                
                NavigationLink(destination: AddTransactionView()) {
                    Text("add_transaction")
                        .foregroundStyle(Color.text_color)
                }
                .buttonStyle(.plain)
                .padding(.vertical, 12)
                .padding(.horizontal, 18)
                .background(Color.primary_color)
                .cornerRadius(6)
                .padding(.trailing, 18)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("dashboard_greeting \(username)")
                        .modifier(UrbanistFont(.regular, size: 18))
                        .foregroundColor(Color.text_color)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("dashboard_add_menu", systemImage: "plus") {
                        NavigationLink(destination: AddTransactionView()) {
                            Text("add_transaction")
                        }
                        .buttonStyle(.plain)
                        NavigationLink(destination: AddIncomeSourceView()) {
                            Text("add_source")
                        }
                        .buttonStyle(.plain)
                        NavigationLink(destination: AddExpenseCategoryView()) {
                            Text("add_category")
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
