//
//  OnboardingBalanceView.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI

struct OnboardingBalanceView: View {
    @Environment(\.modelContext) var modelContext
    
    @Bindable var account: Account
    @Binding var isCompleted: Bool
    @State private var balance: String = ""
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        return formatter
    }()
    
    var body: some View {
        ZStack {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            VStack {
                Text(String(localized: "ob_balance_title"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(UrbanistFont(.bold, size: 30))
                    .padding(.bottom, 36)
                
                Text(String(format: String(localized: "ob_balance_subtitle"), account.name))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(UrbanistFont(.regular, size: 18))
                
                Spacer()
                
                TextField(String(localized: "ob_balance_hint"), value: $account.balance, formatter: formatter)
                    .textFieldStyle(AppTextFieldStyle(left: "💰", right: "€"))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                
                Button {
                    saveAccount()
                } label: {
                    Text(String(localized: "save"))
                        .modifier(UrbanistFont(.bold, size: 18))
                        .foregroundColor(Color.bg_color)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .background(account.balance <= 0 ? Color.gray : Color.primary_color)
                .cornerRadius(12)
                .padding(.top, 25)
                .disabled(account.balance <= 0)
            }
            .padding(24)
        }
    }
    
    private func saveAccount() {
        modelContext.insert(account)
        isCompleted = true
    }
}

#Preview {
    OnboardingBalanceView(account: Account(name: "Cash"), isCompleted: .constant(false))
}
