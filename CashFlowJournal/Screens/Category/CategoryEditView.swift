//
//  CategoryEditView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 04.01.2024.
//

import SwiftUI
import SwiftData

struct CategoryEditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query private var groups: [CategoryGroup]
    
    @Bindable private var category: Category
    @State private var color: Color
    
    init(category: Category? = nil) {
        let categoryColorHEX = category?.color ?? Color.random().toHex()
        self._color = State(initialValue: Color(hex: categoryColorHEX))
        self.category = category ?? Category(name: "", color: categoryColorHEX, icon: "bag")
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                TextField("add_category_hint", text: $category.name)
                    .foregroundStyle(Color.text_color)
                    .textFieldStyle(AppTextFieldStyle(left: "🏷️"))
                
                CustomColorPicker(hint: "add_category_color_hint", color: $color)
                    .padding(.top, 24)
                    .onChange(of: color) { _, value in
                        category.color = value.toHex()
                    }
                
                CustomIconPicker(hint: "add_category_icon_hint", icon: $category.icon, color: $color)
                
                if groups.count > 0 {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("add_category_group_hint")
                            .modifier(UrbanistFont(.regular, size: 18))
                        
                        EntityPicker(items: groups, selectedItem: $category.group)
                    }
                }
                
                Spacer()
                
                Button {
                    saveCategory()
                } label: {
                    Text("save")
                        .modifier(UrbanistFont(.bold, size: 18))
                        .foregroundColor(Color.bg_color)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .background(category.name.isEmpty ? Color.gray : Color.primary_color)
                .cornerRadius(12)
                .disabled(category.name.isEmpty)
            }
            .padding()
        }
        .navigationTitle(category.name.isEmpty ? "add_category" : "edit_category")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func saveCategory() {
        modelContext.insert(category)
        dismiss()
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            CategoryEditView()
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
