//
//  IconPickerModalView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 04.01.2024.
//

import SwiftUI

struct IconPickerModalView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var isFirstTimeAppeared = false
    @State private var searchText = ""
    @State private var symbols: [String] = []
    
    @Binding var selection: String
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 20) {
                    ForEach(symbols.filter { searchText.isEmpty ? true : $0.contains(searchText.lowercased()) }, id: \.hash) { icon in
                        
                        Button {
                            self.selection = icon
                        } label: {
                            Image(systemName: icon)
                                .font(.system(size: 25))
                                .foregroundColor(self.selection == icon ? Color.primary_color : Color.text_color)
                        }
                    }.padding(.top, 5)
                }
            }
            .navigationTitle("icon_picker_title")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                    
                }
            }
            .tint(Color.gray)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: selection) { _, _ in
            dismiss()
        }
        .onAppear {
            if(!isFirstTimeAppeared) {
                self.symbols = loadSymbols()
            }
        }
    }
    
    private func loadSymbols() -> [String] {
        guard
            let bundle = Bundle(identifier: "com.apple.CoreGlyphs"),
            let resourcePath = bundle.path(forResource: "name_availability", ofType: "plist"),
            let plist = NSDictionary(contentsOfFile: resourcePath),
            let plistSymbols = plist["symbols"] as? [String: String]
        else {
            return [String]()
        }
        
        return Array(plistSymbols.keys)
    }
}

#Preview {
    IconPickerModalView(selection: .constant("dollarsign"))
}
