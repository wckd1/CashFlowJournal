//
//  OnboardingBalanceView.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI

struct OnboardingBalanceView: View {
    @Binding var isCompleted: Bool
    @State private var balance: String = ""
    
    var body: some View {
        VStack {
            Text(String(localized: "ob_balance_title"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(UrbanistFont(.bold, size: 30))
                .padding(.bottom, 36)
            
            Text(String(localized: "ob_balance_subtitle"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(UrbanistFont(.regular, size: 18))
            
            Spacer()
            
            TextField(String(localized: "ob_balance_hint"), text: $balance)
                .modifier(UrbanistFont(.regular, size: 18))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .keyboardType(.decimalPad)
            Divider()
                .padding(.horizontal, 8)
            
            Button {
                isCompleted = true
            } label: {
                Text(String(localized: "save"))
                    .modifier(UrbanistFont(.bold, size: 18))
                    .foregroundColor(Color.bg_color)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .background(balance.isEmpty ? Color.gray : Color.primary_color)
            .cornerRadius(12)
            .padding(.top, 25)
            .disabled(balance.isEmpty)
        }
        .padding(24)
    }
}

#Preview {
    OnboardingBalanceView(isCompleted: .constant(false))
}
