//
//  AppTextFieldStyle.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 29.12.2023.
//

import SwiftUI

struct AppTextFieldStyle: TextFieldStyle {
    var left: String?
    var right: String?
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            if let left {
                Text(left)
            }
            
            configuration
                .modifier(UrbanistFont(.regular, size: 18))
                .foregroundStyle(Color.text_color)
            
            if let right {
                Text(right)
            }
        }
        .overlay(
            Rectangle()
                .frame(height: 1)
                .padding(.top, 48)
                .foregroundStyle(.placeholder)
        )
    }
}
