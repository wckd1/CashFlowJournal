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
    var id: String {
        source.name
    }
    
    let source: Source
    let amount: Float
}

struct SourcesView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var sources: [Source]
    @Query private var transactions: [Transaction]
    
    init() {
        _transactions = Query(
            filter: #Predicate<Transaction> { transaction in
                transaction.source != nil
            }
        )
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
                        .padding(.top, 12)
                    
                    List {
                        ForEach(sources) { source in
                            NavigationLink(destination: SourceDetailsView(source: source)) {
                                SourceCell(source: source)
                            }
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
    
    private func deleteSources(at offsets: IndexSet) {
        for offset in offsets {
            let source = sources[offset]
            modelContext.delete(source)
        }
    }
    
    private func chartData() -> [ChartData] {
        // Income
        let sourcesGroup = Dictionary(grouping: transactions) { $0.source! }
        
        return sourcesGroup.map { k, v in
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
