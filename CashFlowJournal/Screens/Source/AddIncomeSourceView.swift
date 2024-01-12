//
//  AddIncomeSourceView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 03.01.2024.
//

import SwiftUI

struct AddIncomeSourceView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Bindable private var source = Source(name: "", color: Color.primary_color.toHex(), icon: "dollarsign")
    
    @State private var color = Color.random()
    @State private var isIconPickerPresented = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                TextField("add_source_hint", text: $source.name)
                    .foregroundStyle(Color.text_color)
                    .textFieldStyle(AppTextFieldStyle(left: "💸"))
                
                ColorPicker("add_source_color_hint", selection: $color, supportsOpacity: false)
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundStyle(Color.text_color)
                    .padding(.top, 24)
                    .onChange(of: color) { _, value in
                        source.color = value.toHex()
                    }
                
                HStack {
                    Text("add_source_icon_hint")
                        .modifier(UrbanistFont(.regular, size: 18))
                    Spacer()
                    Image(systemName: source.icon)
                        .font(.title3)
                        .foregroundStyle(color)
                }
                .onTapGesture {
                    isIconPickerPresented.toggle()
                }
                .sheet(isPresented: $isIconPickerPresented, content: {
                    IconPickerModalView(selection: $source.icon)
                })
                
                Spacer()
                
                Button {
                    saveSource()
                } label: {
                    Text("save")
                        .modifier(UrbanistFont(.bold, size: 18))
                        .foregroundColor(Color.bg_color)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .background(source.name.isEmpty ? Color.gray : Color.primary_color)
                .cornerRadius(12)
                .padding(.top, 25)
                .disabled(source.name.isEmpty)
            }
            .padding(24)
        }
        .navigationTitle("add_source")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func saveSource() {
        modelContext.insert(source)
        dismiss()
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            AddIncomeSourceView()
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
