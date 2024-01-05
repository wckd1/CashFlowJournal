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
                    if transactions.count < 1 {
                        ContentUnavailableView(
                            String(localized: "dashboard_no_transactions_title"),
                            systemImage: "clipboard",
                            description: Text("dashboard_no_transactions_description")
                        )
                    } else {
                        Text("dashboard_transactions_title")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .modifier(UrbanistFont(.regular, size: 24))
                            .foregroundColor(Color.text_color)
                            .padding(.bottom, 12)
                            .padding(.horizontal, 12)
                        
                        List {
                            ForEach(transactions) { transaction in
                                // TODO: Transaction details
                                TransactionCell(transaction: transaction)
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
