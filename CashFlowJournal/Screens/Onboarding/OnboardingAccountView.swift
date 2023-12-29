//
//  OnboardingAccountView.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI

struct OnboardingAccountView: View {
    @Binding var isCompleted: Bool
    @Bindable private var account = Account(name: "")
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color.bg_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text(String(localized: "ob_account_title"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(UrbanistFont(.bold, size: 30))
                        .padding(.bottom, 36)
                    
                    Text(String(localized: "ob_account_subtitle"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(UrbanistFont(.regular, size: 18))
                    
                    Spacer()
                    
                    TextField(String(localized: "ob_account_hint"), text: $account.name)
                        .textFieldStyle(AppTextFieldStyle(left: "🏦"))
                    
                    NavigationLink(
                        destination: OnboardingBalanceView(account: account, isCompleted: $isCompleted)
                    ) {
                        Text(String(localized: "create_account"))
                            .modifier(UrbanistFont(.bold, size: 18))
                            .foregroundColor(Color.bg_color)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .background(account.name.isEmpty ? Color.gray : Color.primary_color)
                    .cornerRadius(12)
                    .padding(.top, 25)
                    .disabled(account.name.isEmpty)
                }
                .padding(24)
            }
        }
    }
}

#Preview {
    OnboardingAccountView(isCompleted: .constant(false))
}
