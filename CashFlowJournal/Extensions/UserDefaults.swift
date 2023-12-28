//
//  UserDefaults.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 28.12.2023.
//

import Foundation

extension UserDefaults {
    
    static var username: String {
        get {
            UserDefaults.standard.string(forKey: Constants.Preferences.USERNAME) ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.Preferences.USERNAME)
        }
    }
    
    static var isOnboarded: Bool {
        get {
            UserDefaults.standard.bool(forKey: Constants.Preferences.IS_ONBOARDED)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.Preferences.IS_ONBOARDED)
        }
    }
}
