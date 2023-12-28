//
//  RegistrationView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 28.12.2023.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var username: String
    @State private var usernameValue: String = ""
    
    var body: some View {
        ZStack {
            Color.bg.edgesIgnoringSafeArea(.all)
            
            VStack() {
                Spacer()
                Text("Let's \nget to know \neach other!")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(Font.system(size: 45))
                
                Spacer()
                
                TextField("Enter your name", text: $usernameValue)
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
