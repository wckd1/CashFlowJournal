//
//  TransactionDetailsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 12.01.2024.
//

import SwiftUI

struct TransactionDetailsView: View {
    let transaction: Transaction
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 18) {
                // Date
                Text(transaction.date.formatted(date: .long, time: .shortened))
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundColor(Color.gray)
                
                // Amount
                Text(Formatter.shared.format(transaction.amount))
                    .modifier(UrbanistFont(.regular, size: 30))
                    .foregroundColor(transaction.type.color)
                    .multilineTextAlignment(.leading)
                
                // Origin account
                LabeledContent("origin_account") {
                    NavigationLink {
                        AccountDetailsView(account: transaction.originAccount!)
                    } label: {
                        Text(transaction.originAccount!.name)
                            .foregroundStyle(Color(hex: transaction.originAccount!.color))
                    }
                }
                if let group = transaction.originAccount?.group {
                    LabeledContent("origin_account_group") {
                        Text(group.name)
                            .foregroundStyle(Color.text_color)
                    }
                }
                
                switch transaction.type {
                // Income source
                case .income:
                    LabeledContent("income_source") {
                        NavigationLink {
                            SourceDetailsView(source: transaction.source!)
                        } label: {
                            Text(transaction.source!.name)
                                .foregroundStyle(Color(hex: transaction.source!.color))
                        }
                    }
                    if let group = transaction.source?.group {
                        LabeledContent("income_source_group") {
                            Text(group.name)
                                .foregroundStyle(Color.text_color)
                        }
                    }
                // Expense category
                case .expense:
                    LabeledContent("expense_category") {
                        NavigationLink {
                            CategoryDetailsView(category: transaction.category!)
                        } label: {
                            Text(transaction.category!.name)
                                .foregroundStyle(Color(hex: transaction.category!.color))
                        }
                    }
                    if let group = transaction.category?.group {
                        LabeledContent("expense_category_group") {
                            Text(group.name)
                                .foregroundStyle(Color.text_color)
                        }
                    }
                // TODO: Origin account showed instead of destination
                // Detination account
                case .transfer:
                    LabeledContent("target_account") {
                        NavigationLink {
                            AccountDetailsView(account: transaction.account!)
                        } label: {
                            Text(transaction.account!.name)
                                .foregroundStyle(Color(hex: transaction.account!.color))
                        }
                    }
                    if let group = transaction.account?.group {
                        LabeledContent("target_account_group") {
                            Text(group.name)
                                .foregroundStyle(Color.text_color)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
        }
        .navigationTitle(transaction.title)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            TransactionDetailsView(transaction: previewer.transactions[0])
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
