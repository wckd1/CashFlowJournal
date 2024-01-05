//
//  TransactionAccountPicker.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI

struct TransactionAccountPicker: View {
    @State var accounts: [Account]
    @Binding var selectedAccount: Account?
    
    var body: some View {
        Group {
            Text("add_transaction_account_hint")
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(UrbanistFont(.regular, size: 18))
                .foregroundStyle(Color.text_color)
                .padding(.top, 18)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(accounts) { account in
                        Button {
                            selectedAccount = account
                        } label: {
                            Text(account.name)
                                .foregroundStyle(Color.text_color)
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 18)
                        .background(selectedAccount == account ? Color.primary_color : Color.gray)
                        .cornerRadius(6)
                    }
                }
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionAccountPicker(accounts: previewer.accounts, selectedAccount: .constant(previewer.accounts[0]))
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}