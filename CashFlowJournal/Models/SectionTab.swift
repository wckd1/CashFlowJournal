//
//  SectionTab.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 17.01.2024.
//

import SwiftUI

enum SectionTab: String {
    case dashboard = "Dashboard"
    case reporst = "Reports"
    case settings = "Settings"
    
    @ViewBuilder
    var tabContent: some View {
        switch self {
        case .dashboard:
            Image(systemName: "calendar")
            Text(self.rawValue)
        case .reporst:
            Image(systemName: "chart.bar")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gearshape")
            Text(self.rawValue)
        }
    }
}
