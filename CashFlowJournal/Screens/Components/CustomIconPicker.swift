//
//  CustomIconPicker.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 12.01.2024.
//

import SwiftUI

struct CustomIconPicker: View {
    
    let hint: String.LocalizationValue
    @Binding var icon: String
    @Binding var color: Color
    
    @State private var isIconPickerPresented = false
    
    var body: some View {
        HStack {
            Text(String(localized: hint))
                .modifier(UrbanistFont(.regular, size: 18))
            
            Spacer()
            
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
                .onTapGesture {
                    isIconPickerPresented.toggle()
                }
        }
        .sheet(isPresented: $isIconPickerPresented, content: {
            IconPickerModalView(selection: $icon)
        })
    }
}

#Preview {
    CustomIconPicker(hint: "add_category_icon_hint", icon: .constant("bag"), color: .constant(Color.primary_color))
}
