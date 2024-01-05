//
//  AccountCell.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI

struct AccountCell: View {
    var account: Account
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: account.color))
                .frame(width: 42, height: 42)
            
            HStack(alignment: .top, spacing: 12) {
                Text(account.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundColor(Color.text_color)
                
                Text(Formatter.shared.format(account.balance))
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundColor(Color.primary_color)
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return AccountCell(account: previewer.accounts[1])
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
