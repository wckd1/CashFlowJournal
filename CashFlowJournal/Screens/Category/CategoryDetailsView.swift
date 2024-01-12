//
//  CategoryDetailsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 07.01.2024.
//

import SwiftUI
import SwiftData

struct CategoryDetailsView: View {
    let category: Category
    @State private var selectedPeriod: PeriodFilter = .month
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                Group {
                    Text("Total expense:\n" + Formatter.shared.format(category.transactions.reduce(0) {$0 + $1.amount }))
                        .modifier(UrbanistFont(.regular, size: 24))
                        .foregroundColor(Color.text_color)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 24)
                    
                    Picker("picker_period_hint", selection: $selectedPeriod) {
                        ForEach(PeriodFilter.allCases , id: \.self) {
                            Text($0.title).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal, 12)
                
                TransactionsList(transactions: category.transactions.filter(period: selectedPeriod))
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            CategoryDetailsView(category: previewer.categories[0])
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
