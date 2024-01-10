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
                        List {
                            ForEach(sortedTransactions) { group in
                                Section {
                                    ForEach(group.transactions) { transaction in
                                        // TODO: Transaction details
                                        TransactionCell(transaction: transaction)
                                    }
                                } header: {
                                    Text(group.id)
                                        .modifier(UrbanistFont(.regular, size: 18))
                                        .foregroundColor(Color.text_color)
                                }
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
                            .listRowBackground(Color.bg_color)
                        }
                        .listStyle(.plain)
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
                    Menu("dashboard_manage_menu", systemImage: "squares.leading.rectangle") {
                        NavigationLink(destination: AccountsView()) {
                            Text("dashboard_accounts")
                        }
                        .buttonStyle(.plain)
                        NavigationLink(destination: SourcesView()) {
                            Text("dashboard_sources")
                        }
                        .buttonStyle(.plain)
                        NavigationLink(destination: CategoriesView()) {
                            Text("dashboard_categories")
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
