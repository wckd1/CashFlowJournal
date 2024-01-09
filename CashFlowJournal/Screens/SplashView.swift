//
//  SplashView.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI
import SwiftData

struct SplashView: View {
    @Environment(\.modelContext) var modelContext
    
    @AppStorage(UserDefaults.usernameKey)
    private var username: String = ""
    
    @AppStorage(UserDefaults.isOnboardedKey)
    private var isOnboarded: Bool = false
    
    var body: some View {
        if username.isEmpty {
            RegistrationView(username: $username)
        } else if !isOnboarded {
            OnboardingAccountView(isCompleted: $isOnboarded)
        } else {
            DashboardView()
        }
    }
}

#Preview {
    SplashView()
}
