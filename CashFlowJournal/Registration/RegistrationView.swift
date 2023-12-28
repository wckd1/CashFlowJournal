//
//  RegistrationView.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var username: String
    @State private var usernameValue: String = ""
    
    var body: some View {
        ZStack {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 6) {
                Spacer()
                
                Text(String(localized: "registration_title_first"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(UrbanistFont(.regular, size: 36))
                    .foregroundColor(Color.text_color)
                Text(String(localized: "registration_title_second"))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(UrbanistFont(.bold, size: 42))
                    .foregroundColor(Color.text_color)
                HStack(spacing: 12) {
                    Text(String(localized: "registration_title_third"))
                        .modifier(UrbanistFont(.regular, size: 30))
                    Text(String(localized: "registration_title_fourth"))
                        .modifier(UrbanistFont(.bold, size: 30))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .foregroundColor(Color.bg_color)
                        .background(Color.primary_color)
                        .cornerRadius(12)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 6)
                
                Spacer()
                
                TextField(String(localized: "registration_username_hint"), text: $usernameValue)
                    .modifier(UrbanistFont(.regular, size: 18))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .onSubmit {
                        guard usernameValue.isEmpty == false else { return }
                        username = usernameValue
                    }
                    .submitLabel(.continue)
                Divider()
                    .padding(.horizontal, 8)
                
                Spacer()
            }
            .padding(24)
        }
    }
}

#Preview {
    RegistrationView(username: .constant(""))
}
