//
//  SourcesView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI
import SwiftData

struct SourcesView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var sources: [Source]
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            if sources.count < 1 {
                ContentUnavailableView(
                    String(localized: "no_sources_title"),
                    systemImage: "clipboard",
                    description: Text("no_sources_description")
                )
            } else {
                List {
                    ForEach(sources) { source in
                        // TODO: Source details
                        SourceCell(source: source)
                    }
                    .onDelete(perform: deleteSources)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
                    .listRowBackground(Color.bg_color)
                }
                .listStyle(.plain)
                .padding(.vertical, 6)
            }
        }
        .navigationTitle("dashboard_sources")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            NavigationLink(destination: AddIncomeSourceView()) {
                Image(systemName: "plus")
                    .foregroundStyle(Color.primary_color)
            }
            .buttonStyle(.plain)
        }
    }
    
    func deleteSources(at offsets: IndexSet) {
        for offset in offsets {
            let source = sources[offset]
            modelContext.delete(source)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            SourcesView()
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
