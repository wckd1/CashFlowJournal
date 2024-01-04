//
//  ColorExtensions.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 28.12.2023.
//

import SwiftUI

extension Color {
    static let bg_color = Color("CashFlowBackground")
    static let primary_color = Color("CashFlowPrimary")
    static let text_color = Color("CashFlowTextColor")
    static let income_color = Color("CashFlowPrimary")
    static let expense_color = Color("CashFlowRed")
}

extension TransactionType {
    var color: Color {
        switch self {
        case .income: return Color.income_color
        case .expense: return Color.expense_color
        }
    }
}
