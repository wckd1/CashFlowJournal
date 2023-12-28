//
//  CashFlowJournalApp.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI

@main
struct CashFlowJournalApp: App {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .preferredColorScheme(colorScheme)
//                .onAppear {
//                    UserDefaults.username = ""
//                }
        }
    }
}
