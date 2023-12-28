//
//  SplashView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 28.12.2023.
//

import SwiftUI

struct SplashView: View {
    @AppStorage(Constants.Preferences.USERNAME)
    private var username: String = UserDefaults.username
    
    @State private var isOnboarded: Bool = UserDefaults.isOnboarded
    
    var body: some View {
        if username != "" {
            // Check onboarding
            Text(username)
        } else {
            RegistrationView(username: $username)
        }
    }
}

#Preview {
    SplashView()
}
