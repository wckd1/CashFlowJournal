//
//  OnboardingView.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage(UserDefaults.usernameKey)
    private var username: String = ""
    
    @AppStorage(UserDefaults.isOnboardedKey)
    private var isOnboarded: Bool = false
    
    var body: some View {
        if username.isEmpty {
            RegistrationView(username: $username)
        } else {
            OnboardingAccountView(isCompleted: $isOnboarded)
        }
    }
}

#Preview {
    OnboardingView()
}
