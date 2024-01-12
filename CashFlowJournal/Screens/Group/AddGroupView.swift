//
//  AddGroupView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 11.01.2024.
//

import SwiftUI
import SwiftData

typealias EntityGroupModel = EntityGroup & PersistentModel

struct AddGroupView<T: EntityGroupModel>: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Bindable private var group: T
    
    init() {
        self.group = T(name: "")
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                TextField("add_group_hint", text: $group.name)
                    .foregroundStyle(Color.text_color)
                    .textFieldStyle(AppTextFieldStyle(left: "🏷️"))
                
                Spacer()
                
                Button {
                    saveGroup()
                } label: {
                    Text("save")
                        .modifier(UrbanistFont(.bold, size: 18))
                        .foregroundColor(Color.bg_color)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .background(group.name.isEmpty ? Color.gray : Color.primary_color)
                .cornerRadius(12)
                .padding(.top, 25)
                .disabled(group.name.isEmpty)
            }
            .padding(24)
        }
        .navigationTitle("add_group")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func saveGroup() {
        modelContext.insert(group)
        dismiss()
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            AddGroupView<AccountGroup>()
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
