//
//  TransactionCategoryPicker.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI

struct TransactionCategoryPicker: View {
    @State var categories: [Category]
    @Binding var selectedCategory: Category?
    
    var body: some View {
        Text("add_transaction_category_hint")
            .frame(maxWidth: .infinity, alignment: .leading)
            .modifier(UrbanistFont(.regular, size: 18))
            .foregroundStyle(Color.text_color)
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        HStack {
                            Image(systemName: category.icon)
                                .font(.subheadline)
                                .foregroundStyle(Color.text_color)
                            Text(category.name)
                                .foregroundStyle(Color.text_color)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 18)
                    .background(selectedCategory == category ? Color(hex: category.color) : Color.gray)
                    .cornerRadius(6)
                }
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionCategoryPicker(categories: previewer.categories, selectedCategory: .constant(previewer.categories[0]))
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
