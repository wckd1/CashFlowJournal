//
//  CategoryDetailsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 07.01.2024.
//

import SwiftUI
import SwiftData

struct CategoryDetailsView: View {
    private let category: Category
    @Query private var transactions: [Transaction]
    @State private var filteredTransactions: [Transaction] = []
    @State private var selectedPeriod: PeriodFilter = .overall
    
    init(category: Category) {
        self.category = category
        
        _transactions = Query(
            filter: CategoryDetailsView.categoryPredicate(category.id),
            sort: \.date, order: .reverse
        )
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                Group {
                    Text("Total expense:\n" + Formatter.shared.format(transactions.reduce(0) {$0 + $1.amount }))
                        .modifier(UrbanistFont(.regular, size: 24))
                        .foregroundColor(Color.text_color)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 24)
                    
                    Picker("add_transaction_type_hint", selection: $selectedPeriod) {
                        ForEach(PeriodFilter.categoryCases , id: \.self) {
                            Text($0.title).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal, 12)
                
                if filteredTransactions.count < 1 {
                    ContentUnavailableView(
                        String(localized: "no_transactions_title"),
                        systemImage: "clipboard",
                        description: Text("no_transactions_description")
                    )
                } else {
                    List {
                        Section {
                            ForEach(filteredTransactions) { transaction in
                                TransactionCell(transaction: transaction)
                            }
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                            .listRowBackground(Color.bg_color)
                        } header: {
                            Text("dashboard_transactions_title")
                                .modifier(UrbanistFont(.regular, size: 18))
                                .foregroundColor(Color.text_color)
                        }
                    }
                    .listStyle(.plain)
                    .padding(.vertical, 6)
                    .listSectionSpacing(.compact)
                }
            }
            .onChange(of: selectedPeriod) { _, _ in
                reloadTransactions()
            }
            .onAppear {
                reloadTransactions()
            }
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func reloadTransactions() {
        if let interval = selectedPeriod.periodDates() {
            filteredTransactions = transactions.filter { transaction in
                transaction.date >= interval.start
                && transaction.date <= interval.end
            }
        } else {
            filteredTransactions = transactions
        }
    }
    
    private static func categoryPredicate(_ categoryID: UUID) -> Predicate<Transaction> {
        return #Predicate<Transaction> { transaction in
            transaction.category?.id == categoryID
        }
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
