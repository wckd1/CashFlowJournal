//
//  OnboardingAccountView.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI

struct OnboardingAccountView: View {
    @Binding var pageIndex: Int
    @State private var accountName: String = ""
    
    var body: some View {
        VStack {
            Text(String(localized: "ob_account_title"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(UrbanistFont(.bold, size: 30))
                .padding(.bottom, 36)
            
            Text(String(localized: "ob_account_subtitle"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(UrbanistFont(.regular, size: 18))
            
            Spacer()
            
            TextField(String(localized: "ob_account_hint"), text: $accountName)
                .modifier(UrbanistFont(.regular, size: 18))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
            Divider()
                .padding(.horizontal, 8)
            
            Button {
                pageIndex += 1
            } label: {
                Text(String(localized: "create_account"))
                    .modifier(UrbanistFont(.bold, size: 18))
                    .foregroundColor(Color.bg_color)
                    .padding(.vertical, 12)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .background(accountName.isEmpty ? Color.gray : Color.primary_color)
            .cornerRadius(12)
            .padding(.top, 25)
            .disabled(accountName.isEmpty)
        }
        .padding(24)
    }
}

#Preview {
    OnboardingAccountView(pageIndex: .constant(0))
}
