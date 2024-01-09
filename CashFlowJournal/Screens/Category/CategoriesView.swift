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
    var id: UUID {
        category.id
    }
    
    let category: Category
    let amount: Float
}

struct CategoriesView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var categories: [Category]
    @Query private var transactions: [Transaction]
    
    init() {
        _transactions = Query(
            filter: #Predicate<Transaction> { transaction in
                transaction.category != nil
            }
        )
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
                        .padding(.top, 12)
                    
                    List {
                        ForEach(categories) { category in
                            NavigationLink(destination: CategoryDetailsView(category: category)) {
                                CategoryCell(category: category)
                            }
                        }
                        .onDelete(perform: deleteCategories)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
                        .listRowBackground(Color.bg_color)
                    }
                    .listStyle(.plain)
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("dashboard_categories")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            NavigationLink(destination: AddExpenseCategoryView()) {
                Image(systemName: "plus")
                    .foregroundStyle(Color.primary_color)
            }
            .buttonStyle(.plain)
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
