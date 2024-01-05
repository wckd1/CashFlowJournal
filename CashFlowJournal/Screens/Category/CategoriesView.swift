//
//  CategoriesView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query private var categories: [Category]
    
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
                List {
                    ForEach(categories) { category in
                        CategoryCell(category: category)
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
    
    func deleteCategories(at offsets: IndexSet) {
        for offset in offsets {
            let category = categories[offset]
            modelContext.delete(category)
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
