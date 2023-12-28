//
//  OnboardingView.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI

struct OnboardingView: View {
    @State private var pageIndex = 0
    @Binding var isCompleted: Bool
    
    var body: some View {
        ZStack {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            TabView(selection: $pageIndex) {
                OnboardingAccountView(pageIndex: $pageIndex).tag(0)
                OnboardingBalanceView(isCompleted: $isCompleted).tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .transition(.slide)
            .onAppear {
                UIScrollView.appearance().isScrollEnabled = false
            }
        }
    }
}

#Preview {
    OnboardingView(isCompleted: .constant(false))
}
