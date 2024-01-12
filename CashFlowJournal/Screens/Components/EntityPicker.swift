//
//  EntityPicker.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI

typealias EntityPickerItem = Pickerable & Identifiable & Equatable

struct EntityPicker<T: EntityPickerItem>: View {
    @State var items: [T]
    @Binding var selectedItem: T?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                // TODO: Add account if no exists
                ForEach(items) { item in
                    Button {
                        selectedItem = item
                    } label: {
                        HStack {
                            if !item.icon.isEmpty {
                                Image(systemName: item.icon)
                                    .font(.subheadline)
                                    .foregroundStyle(Color.text_color)
                            }
                            Text(item.name)
                                .foregroundStyle(Color.text_color)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 18)
                    .background(selectedItem == item ? Color(hex: item.color) : Color.gray)
                    .cornerRadius(6)
                }
            }
        }
    }
}

protocol Pickerable {
    var name: String { get }
    var icon: String { get }
    var color: String { get }
}

extension Account: Pickerable {
    var icon: String { "" }
}
extension Source: Pickerable {}
extension Category: Pickerable {}
extension AccountGroup: Pickerable {
    var icon: String { "" }
    var color: String { Color.primary_color.toHex() }
}
extension CategoryGroup: Pickerable {
    var icon: String { "" }
    var color: String { Color.primary_color.toHex() }
}
extension SourceGroup: Pickerable {
    var icon: String { "" }
    var color: String { Color.primary_color.toHex() }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return EntityPicker(items: previewer.sources, selectedItem: .constant(previewer.sources[0]))
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
