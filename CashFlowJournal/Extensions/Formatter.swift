//
//  PriceFormatter.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 03.01.2024.
//

import Foundation

class Formatter {
    static let shared = Formatter()
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "EUR"
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    func format(_ price: Float) -> String {
        return priceFormatter.string(from: NSNumber(value: price)) ?? String(describing: price)
    }
}
