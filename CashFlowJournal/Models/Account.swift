//
//  Account.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 29.12.2023.
//

import SwiftData
import Foundation

@Model
class Account {
    var name: String = ""
    var balance: Float = 0.0
    
    init(name: String, balance: Float = 0.0) {
        self.name = name
        self.balance = balance
    }
}
