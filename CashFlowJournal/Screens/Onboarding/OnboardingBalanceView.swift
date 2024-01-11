//
//  OnboardingBalanceView.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI
import SwiftData

struct OnboardingBalanceView: View {
    @Environment(\.modelContext) var modelContext
    
    @Bindable var account: Account
    @Binding var isCompleted: Bool
    @State private var balance: String = ""
    
    var body: some View {
        ZStack {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            VStack {
                Text("ob_balance_title")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(UrbanistFont(.bold, size: 30))
                    .foregroundColor(Color.text_color)
                    .padding(.bottom, 36)
                
                Text("ob_balance_subtitle \(account.name)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundColor(Color.text_color)
                
                Spacer()
                
                TextField("add_account_balance_hint", value: $account.balance, formatter: Formatter.shared.numberFormatter)
                    .textFieldStyle(AppTextFieldStyle(left: "💰", right: "€"))
                    .foregroundColor(Color.text_color)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                
                Button {
                    saveAccount()
                } label: {
                    Text("save")
                        .modifier(UrbanistFont(.bold, size: 18))
                        .foregroundColor(Color.bg_color)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .background(account.balance < 0 ? Color.gray : Color.primary_color)
                .cornerRadius(12)
                .padding(.top, 25)
                .disabled(account.balance < 0)
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
    do {
        let previewer = try Previewer()
        
        return OnboardingBalanceView(account: previewer.accounts[0], isCompleted: .constant(false))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
