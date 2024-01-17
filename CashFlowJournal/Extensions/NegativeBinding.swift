//
//  NegativeBinding.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 17.01.2024.
//

import SwiftUI

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}

