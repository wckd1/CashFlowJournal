//
//  CategoriesView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI
import SwiftData
import Charts

fileprivate struct ChartData: Identifiable {
    var id: PersistentIdentifier { category.persistentModelID }
    
    let category: Category
    let amount: Float
}

struct CategoriesView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var categories: [Category]
    private var categoryGroups: [String: [Category]] {
        Dictionary(grouping: categories, by: { $0.group?.name ?? "" })
    }
    
    private var transactions: [Transaction] {
        return categories.flatMap { $0.transactions }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            if categories.count < 1 {
                ContentUnavailableView(
                    String(localized: "no_categories_title"),
                    systemImage: "clipboard",
                    description: Text("no_categories_description")
                )
            } else {
                VStack {
                    // Chart
                    ZStack() {
                        Chart(chartData()) { item in
                            SectorMark(
                                angle: .value(
                                    Text(verbatim: item.category.name),
                                    item.amount
                                ),
                                innerRadius: .ratio(0.75)
                            )
                            .foregroundStyle(Color(hex: item.category.color))
                        }
                        .frame(height: 240)
                        
                        Text("total \(Formatter.shared.format(transactions.reduce(0) {$0 + $1.amount }))")
                            .modifier(UrbanistFont(.regular, size: 24))
                            .foregroundColor(Color.text_color)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical)
                    
                    // Categories
                    List {
                        ForEach(Array(categoryGroups.keys).sorted(by: <), id: \.self) { key in
                            if let categories = categoryGroups[key] {
                                ForEach(categories) { category in
                                    NavigationLink {
                                        CategoryDetailsView(category: category)
                                    } label: {
                                        CategoryCell(category: category)
                                    }
                                }
                                .modifier(EntitledSection(key))
                            }
                        }
                        .onDelete(perform: deleteCategories)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                        .listRowBackground(Color.bg_color)
                    }
                    .listStyle(.plain)
                    .listSectionSpacing(.compact)
                }
            }
        }
        .navigationTitle("dashboard_categories")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            Menu("dashboard_manage_menu", systemImage: "plus") {
                NavigationLink { AccountEditView() } label: {
                    Text("add_category")
                }
                .buttonStyle(.plain)
                
                NavigationLink { AddGroupView<CategoryGroup>() } label: {
                    Text("add_group")
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func deleteCategories(at offsets: IndexSet) {
        for offset in offsets {
            let category = categories[offset]
            modelContext.delete(category)
        }
    }
    
    private func chartData() -> [ChartData] {
        Dictionary(grouping: transactions) { $0.category! }.map { k, v in
            ChartData(category: k, amount: v.reduce(0) {$0 + $1.amount })
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            CategoriesView()
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
