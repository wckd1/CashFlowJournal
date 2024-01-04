//
//  OnboardingAccountView.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI
import SwiftData

struct OnboardingAccountView: View {
    @Binding var isCompleted: Bool
    @Bindable private var account = Account(name: "")
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color.bg_color.edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text("ob_account_title")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(UrbanistFont(.bold, size: 30))
                        .foregroundColor(Color.text_color)
                        .padding(.bottom, 36)
                    
                    Text("ob_account_subtitle")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.text_color)
                        .modifier(UrbanistFont(.regular, size: 18))
                    
                    Spacer()
                    
                    TextField("ob_account_hint", text: $account.name)
                        .foregroundColor(Color.text_color)
                        .textFieldStyle(AppTextFieldStyle(left: "🏦"))
                    
                    NavigationLink(
                        destination: OnboardingBalanceView(account: account, isCompleted: $isCompleted)
                    ) {
                        Text("create_account")
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
    do {
        let previewer = try Previewer()
        
        return OnboardingAccountView(isCompleted: .constant(false))
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
