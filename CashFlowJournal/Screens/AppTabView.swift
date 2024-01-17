//
//  AppTabView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 17.01.2024.
//

import SwiftUI

struct AppTabView: View {
    
    @AppStorage(UserDefaults.isOnboardedKey)
    private var isOnboarded: Bool = false
    
    @State private var activeTab: SectionTab = .dashboard
    
    var body: some View {
        TabView(selection: $activeTab){
            DashboardView()
                .tag(SectionTab.dashboard)
                .tabItem { SectionTab.dashboard.tabContent }
        }
        .sheet(isPresented: !$isOnboarded) {
            OnboardingView()
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    AppTabView()
}
