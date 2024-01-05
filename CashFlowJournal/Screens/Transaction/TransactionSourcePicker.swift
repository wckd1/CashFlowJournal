//
//  TransactionSourcePicker.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI

struct TransactionSourcePicker: View {
    @State var sources: [Source]
    @Binding var selectedSource: Source?
    
    var body: some View {
        Group {
            Text("add_transaction_source_hint")
                .frame(maxWidth: .infinity, alignment: .leading)
                .modifier(UrbanistFont(.regular, size: 18))
                .foregroundStyle(Color.text_color)
            
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(sources) { source in
                    Button {
                        selectedSource = source
                    } label: {
                        HStack {
                            Image(systemName: source.icon)
                                .font(.subheadline)
                                .foregroundStyle(Color.text_color)
                            Text(source.name)
                                .foregroundStyle(Color.text_color)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 18)
                    .background(selectedSource == source ? Color(hex: source.color) : Color.gray)
                    .cornerRadius(6)
                }
            }
        }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return TransactionSourcePicker(sources: previewer.sources, selectedSource: .constant(previewer.sources[0]))
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}