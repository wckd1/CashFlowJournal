//
//  BalanceView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 04.01.2024.
//

import SwiftUI
import SwiftData

struct BalanceView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var accounts: [Account]
    @State private var isAccountsShown = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text("dashboard_balance \(Formatter.shared.format(accounts.reduce(0) {$0 + $1.balance }))")
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
                Text("dashboard_balance_from_accounts \(accounts.count)")
                    .modifier(UrbanistFont(.regular, size: 12))
                    .foregroundColor(Color.text_color)
            }
            
            Divider()
                .padding(.top, 18)
        }
        .padding(.top, 24)
        .onTapGesture {
            if accounts.count > 1 {
                withAnimation {
                    isAccountsShown.toggle()
                }
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return BalanceView()
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
