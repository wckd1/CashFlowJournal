//
//  TransactionCell.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 29.12.2023.
//

import SwiftUI

struct TransactionCell: View {
    var transaction: Transaction
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            if transaction.type == .income, let source = transaction.source {
                Image(systemName: source.icon)
                    .frame(width: 48, height: 48)
                    .background(Color(hex: source.color))
                    .cornerRadius(12)
            } else if let category = transaction.category {
                Image(systemName: category.icon)
                    .frame(width: 48, height: 48)
                    .background(Color(hex: category.color))
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(transaction.type.color)
                    .frame(width: 48, height: 48)
            }
            
            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 6) {
                    Text(transaction.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(UrbanistFont(.regular, size: 18))
                        .foregroundColor(Color.text_color)
                    
                    Text(Formatter.shared.format(transaction.date))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(UrbanistFont(.regular, size: 12))
                        .foregroundColor(Color.gray)
                }
                
                Text(Formatter.shared.format(transaction.amount))
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundColor(transaction.type.color)
            }
        }
    }
}


#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionCell(transaction: previewer.transactions[1])
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
