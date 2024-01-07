//
//  AccountDetailsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 07.01.2024.
//

import SwiftUI
import SwiftData

struct AccountDetailsView: View {
    private let account: Account
    @Query private var transactions: [Transaction]
    
    init(account: Account) {
        self.account = account
        
        _transactions = Query(
            filter: AccountDetailsView.accountPredicate(account.id),
            sort: \.date, order: .reverse
        )
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                Text(Formatter.shared.format(account.balance))
                    .modifier(UrbanistFont(.regular, size: 30))
                    .foregroundColor(Color.text_color)
                    .multilineTextAlignment(.center)
                    .padding(.vertical, 24)
                
                Text("dashboard_transactions_title")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(UrbanistFont(.regular, size: 24))
                    .foregroundColor(Color.text_color)
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
            }
        }
        .navigationTitle(account.name)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private static func accountPredicate(_ accountID: UUID) -> Predicate<Transaction> {
        return #Predicate<Transaction> { transaction in
            transaction.account.id == accountID
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            AccountDetailsView(account: previewer.accounts[1])
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
