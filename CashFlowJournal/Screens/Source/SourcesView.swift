//
//  SourcesView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI
import SwiftData
import Charts

fileprivate struct ChartData: Identifiable {
    var id: PersistentIdentifier { source.persistentModelID }
    
    let source: Source
    let amount: Float
}

struct SourcesView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var sources: [Source]
    private var sourceGroups: [String: [Source]] {
        Dictionary(grouping: sources, by: { $0.group?.name ?? "" })
    }
    
    private var transactions: [Transaction] {
        return sources.flatMap { $0.transactions }
    }
    
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
                VStack {
                    // Chart
                    ZStack() {
                        Chart(chartData()) { item in
                            SectorMark(
                                angle: .value(
                                    Text(verbatim: item.source.name),
                                    item.amount
                                ),
                                innerRadius: .ratio(0.75)
                            )
                            .foregroundStyle(Color(hex: item.source.color))
                        }
                        .frame(height: 240)
                        
                        Text("total \(Formatter.shared.format(transactions.reduce(0) {$0 + $1.amount }))")
                            .modifier(UrbanistFont(.regular, size: 24))
                            .foregroundColor(Color.text_color)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical)
                    
                    // Sources
                    List {
                        ForEach(Array(sourceGroups.keys).sorted(by: <), id: \.self) { key in
                            if let sources = sourceGroups[key] {
                                ForEach(sources) { source in
                                    NavigationLink {
                                        SourceDetailsView(source: source)
                                    } label: {
                                        SourceCell(source: source)
                                    }
                                }
                                .modifier(EntitledSection(key))
                            }
                        }
                        .onDelete(perform: deleteSources)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                        .listRowBackground(Color.bg_color)
                    }
                    .listStyle(.plain)
                    .listSectionSpacing(.compact)
                }
            }
        }
        .navigationTitle("dashboard_sources")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            Menu("dashboard_manage_menu", systemImage: "plus") {
                NavigationLink { SourceEditView() } label: {
                    Text("add_source")
                }
                .buttonStyle(.plain)
                
                NavigationLink { AddGroupView<SourceGroup>() } label: {
                    Text("add_group")
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func deleteSources(at offsets: IndexSet) {
        for offset in offsets {
            let source = sources[offset]
            modelContext.delete(source)
        }
    }
    
    private func chartData() -> [ChartData] {
        return Dictionary(grouping: transactions) { $0.source! }.map { k, v in
            ChartData(source: k, amount: v.reduce(0) {$0 + $1.amount })
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
