//
//  AddExpenseCategoryView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 04.01.2024.
//

import SwiftUI

struct AddExpenseCategoryView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Bindable private var category = Category(name: "", color: Color.primary_color.toHex(), icon: "bag")
    
    @State private var color = Color.random()
    @State private var isIconPickerPresented = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                TextField("add_category_hint", text: $category.name)
                    .foregroundStyle(Color.text_color)
                    .textFieldStyle(AppTextFieldStyle(left: "🏷️"))
                
                ColorPicker("add_category_color_hint", selection: $color, supportsOpacity: false)
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundStyle(Color.text_color)
                    .padding(.top, 24)
                    .onChange(of: color) { _, value in
                        category.color = value.toHex()
                    }
                
                HStack {
                    Text("add_category_icon_hint")
                        .modifier(UrbanistFont(.regular, size: 18))
                    Spacer()
                    Image(systemName: category.icon)
                        .font(.title3)
                        .foregroundStyle(color)
                }
                .onTapGesture {
                    isIconPickerPresented.toggle()
                }
                .sheet(isPresented: $isIconPickerPresented, content: {
                    IconPicker(selection: $category.icon)
                })
                
                Spacer()
                
                Button {
                    saveCategory()
                } label: {
                    Text("save")
                        .modifier(UrbanistFont(.bold, size: 18))
                        .foregroundColor(Color.bg_color)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .background(category.name.isEmpty ? Color.gray : Color.primary_color)
                .cornerRadius(12)
                .padding(.top, 25)
                .disabled(category.name.isEmpty)
            }
            .padding(24)
        }
        .navigationTitle("add_category")
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
            AddExpenseCategoryView()
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
