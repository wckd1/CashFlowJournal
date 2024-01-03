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
    
    @State private var isAccountsShown = false
    
    @Query private var accounts: [Account]
    @Query private var transactions: [Transaction]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.bg_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    // Balance
                    VStack(spacing: 12) {
                        Text(
                            String(
                                format: String(localized: "dashboard_balance"),
                                Formatter.shared.format(accounts.reduce(0) {$0 + $1.balance })
                            )
                        )
                        .modifier(UrbanistFont(.regular, size: 30))
                        .foregroundColor(Color.text_color)
                        .multilineTextAlignment(.center)
                        
                        if isAccountsShown {
                            ForEach(accounts) { account in
                                HStack {
                                    Text(account.name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .modifier(UrbanistFont(.regular, size: 18))
                                        .foregroundColor(Color.text_color)
                                    
                                    Text(Formatter.shared.format(account.balance))
                                        .modifier(UrbanistFont(.regular, size: 18))
                                        .foregroundColor(Color.text_color)
                                }
                            }
                        } else if accounts.count > 1 {
                            Text(String(format: String(localized: "dashboard_balance_from_accounts"), String(accounts.count)))
                                .modifier(UrbanistFont(.regular, size: 12))
                                .foregroundColor(Color.text_color)
                        }
                    }
                    .onTapGesture {
                        if accounts.count > 1 {
                            withAnimation {
                                isAccountsShown.toggle()
                            }
                        }
                    }
                    // Balance
                    
                    Divider()
                        .padding(.top, 24)
                        .padding(.bottom, 6)
                    
                    if transactions.count > 1 {
                        // Transactions
                        Text(String(localized: "dashboard_transactions_title"))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .modifier(UrbanistFont(.regular, size: 24))
                            .foregroundColor(Color.text_color)
                        
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
                .padding(24)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text(String(format: String(localized: "dashboard_greeting"), username))
                        .modifier(UrbanistFont(.regular, size: 18))
                        .foregroundColor(Color.text_color)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Add", systemImage: "plus") {
                        Button {} label: {
                            Text(String(localized: "add_transaction"))
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
