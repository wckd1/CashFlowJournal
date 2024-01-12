//
//  EntitledSection.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 12.01.2024.
//

import SwiftUI

struct EntitledSection: ViewModifier {
    var title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    func body(content: Content) -> some View {
        if title.isEmpty {
            content
        } else {
            Section {
                content
            } header: {
                Text(title)
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundColor(Color.text_color)
            }
        }
    }
}
