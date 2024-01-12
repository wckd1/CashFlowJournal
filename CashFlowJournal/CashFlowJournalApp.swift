//
//  CashFlowJournalApp.swift
//  CashFlowJournal
//
//  Created by Roman Korobeinikov on 28.12.2023.
//

import SwiftUI
import SwiftData

@main
struct CashFlowJournalApp: App {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .preferredColorScheme(colorScheme)
                .tint(Color.primary_color)
        }
        .modelContainer(for: [Account.self, Transaction.self, Source.self, Category.self, AccountGroup.self, CategoryGroup.self])
    }
}
