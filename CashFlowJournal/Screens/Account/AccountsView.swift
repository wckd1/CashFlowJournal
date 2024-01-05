//
//  AccountsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI
import SwiftData

struct AccountsView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var accounts: [Account]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            List {
                ForEach(accounts) { account in
                    AccountCell(account: account)
                }
                .onDelete(perform: deleteAccounts)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
                .listRowBackground(Color.bg_color)
            }
            .listStyle(.plain)
            .padding(.vertical, 6)
        }
        .navigationTitle("dashboard_accounts")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            NavigationLink(destination: AddAccountView()) {
                Image(systemName: "plus")
                    .foregroundStyle(Color.primary_color)
            }
            .buttonStyle(.plain)
        }
    }
    
    func deleteAccounts(at offsets: IndexSet) {
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
