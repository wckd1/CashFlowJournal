//
//  AccountsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI
import SwiftData
import Charts

struct AccountsView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var accounts: [Account]
    private var accountGroups: [String: [Account]] {
        Dictionary(grouping: accounts, by: { $0.group?.name ?? "" })
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            if accounts.count < 1 {
                ContentUnavailableView(
                    String(localized: "no_accounts_title"),
                    systemImage: "clipboard",
                    description: Text("no_accounts_description")
                )
            } else {
                VStack {
                    // Chart
                    ZStack() {
                        Chart(accounts) { account in
                            SectorMark(
                                angle: .value(
                                    Text(verbatim: account.name),
                                    account.balance
                                ),
                                innerRadius: .ratio(0.75)
                            )
                            .foregroundStyle(Color(hex: account.color))
                        }
                        .frame(height: 240)
                        
                        Text("total \(Formatter.shared.format(accounts.reduce(0) {$0 + $1.balance }))")
                            .modifier(UrbanistFont(.regular, size: 24))
                            .foregroundColor(Color.text_color)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical)
                    
                    // Accounts
                    List {
                        ForEach(Array(accountGroups.keys).sorted(by: <), id: \.self) { key in
                            if let accounts = accountGroups[key] {
                                ForEach(accounts) { account in
                                    NavigationLink {
                                        AccountDetailsView(account: account)
                                    } label: {
                                        AccountCell(account: account)
                                    }
                                }
                                .modifier(EntitledSection(key))
                            }
                        }
                        .onDelete(perform: deleteAccounts)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                        .listRowBackground(Color.bg_color)
                    }
                    .listStyle(.plain)
                    .listSectionSpacing(.compact)
                }
            }
        }
        .navigationTitle("dashboard_accounts")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            Menu("dashboard_manage_menu", systemImage: "plus") {
                NavigationLink { AccountEditView() } label: {
                    Text("add_account")
                }
                .buttonStyle(.plain)
                
                NavigationLink { AddGroupView<AccountGroup>() } label: {
                    Text("add_group")
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func deleteAccounts(at offsets: IndexSet) {
        for offset in offsets {
            let account = accounts[offset]
            modelContext.delete(account)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            AccountsView()
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}

extension View {
    func headeredSection(title: String) -> any View {
        if title.isEmpty {
            self
        } else {
            Section {
                self
            } header: {
                Text(title)
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundColor(Color.text_color)
            }
        }
    }
}
