//
//  UserDefaults.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 28.12.2023.
//

import Foundation

extension UserDefaults {
    
    static let usernameKey = "username"
    static let isOnboardedKey = "isOnboarded"
    
    static var username: String {
        get {
            UserDefaults.standard.string(forKey: UserDefaults.usernameKey) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.usernameKey)
        }
    }
    
    static var isOnboarded: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaults.isOnboardedKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefaults.isOnboardedKey)
        }
    }
}
