//
//  SplashView.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI

struct SplashView: View {
    @AppStorage(Constants.Preferences.USERNAME)
    private var username: String = UserDefaults.username
    
    @State private var isOnboarded: Bool = UserDefaults.isOnboarded
    
    var body: some View {
        if username.isEmpty {
            RegistrationView(username: $username)
        } else if !isOnboarded {
            OnboardingView(isCompleted: $isOnboarded)
        } else {
            Text(username)
        }
    }
}

#Preview {
    SplashView()
}
