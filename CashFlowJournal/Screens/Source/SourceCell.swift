//
//  SourceCell.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI

struct SourceCell: View {
    let source: Source
    
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: source.icon)
                .frame(width: 42, height: 42)
                .background(Color(hex: source.color))
                .cornerRadius(12)
            
            HStack(alignment: .top, spacing: 12) {
                Text(source.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundColor(Color.text_color)
            }
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return SourceCell(source: previewer.sources[0])
            .modelContainer(previewer.container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
