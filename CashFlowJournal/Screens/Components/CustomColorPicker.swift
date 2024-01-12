//
//  CustomColorPicker.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 12.01.2024.
//

import SwiftUI

struct CustomColorPicker: View {
    
    let hint: String.LocalizationValue
    @Binding var color: Color
    
    var body: some View {
        HStack {
            Text(String(localized: hint))
                .modifier(UrbanistFont(.regular, size: 18))
            
            Spacer()
            
            color
                .frame(width: 24, height: 24, alignment: .center)
                .cornerRadius(6.0)
                .overlay(
                    ColorPicker(
                        String(localized: hint),
                        selection: $color
                    )
                    .labelsHidden()
                    .opacity(0.015)
                )
        }
    }
}

#Preview {
    CustomColorPicker(hint: "add_account_color_hint", color: .constant(Color.primary_color))
}
