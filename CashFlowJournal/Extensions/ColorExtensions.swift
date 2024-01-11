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
    static let error_color = Color("CashFlowRed")
    
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        print(cleanHexCode)
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
    
    func toHex() -> String {
        guard let components = UIColor(self).cgColor.components else {
            return ""
        }
        
        let hexRed = String(format: "%02X", Int(components[0] * 255))
        let hexGreen = String(format: "%02X", Int(components[1] * 255))
        let hexBlue = String(format: "%02X", Int(components[2] * 255))

        return "#" + hexRed + hexGreen + hexBlue
    }
    
    static func random() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)

        return Color(red: red, green: green, blue: blue)
    }
}

extension TransactionType {
    var color: Color {
        switch self {
        case .income: return Color.income_color
        case .expense: return Color.expense_color
        case .transfer: return Color.text_color
        }
    }
}
