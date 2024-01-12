//
//  SourceEditView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 03.01.2024.
//

import SwiftUI
import SwiftData

struct SourceEditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query private var groups: [SourceGroup]
    
    @Bindable private var source: Source
    @State private var color: Color
    
    init(source: Source? = nil) {
        let sourceColorHEX = source?.color ?? Color.random().toHex()
        self._color = State(initialValue: Color(hex: sourceColorHEX))
        self.source = source ?? Source(name: "", color: sourceColorHEX, icon: "dollarsign")
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                TextField("add_source_hint", text: $source.name)
                    .foregroundStyle(Color.text_color)
                    .textFieldStyle(AppTextFieldStyle(left: "💸"))
                
                CustomColorPicker(hint: "add_source_color_hint", color: $color)
                    .padding(.top, 24)
                    .onChange(of: color) { _, value in
                        source.color = value.toHex()
                    }
                
                CustomIconPicker(hint: "add_source_icon_hint", icon: $source.icon, color: $color)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("add_source_group_hint")
                        .modifier(UrbanistFont(.regular, size: 18))
                    
                    EntityPicker(items: groups, selectedItem: $source.group)
                }
                
                Spacer()
                
                Button {
                    saveSource()
                } label: {
                    Text("save")
                        .modifier(UrbanistFont(.bold, size: 18))
                        .foregroundColor(Color.bg_color)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .background(source.name.isEmpty ? Color.gray : Color.primary_color)
                .cornerRadius(12)
                .disabled(source.name.isEmpty)
            }
            .padding(24)
        }
        .navigationTitle(source.name.isEmpty ? "add_source" : "edit_source")
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
            SourceEditView()
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
