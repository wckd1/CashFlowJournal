//
//  SourceDetailsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 07.01.2024.
//

import SwiftUI
import SwiftData

struct SourceDetailsView: View {
    private let source: Source
    @Query private var transactions: [Transaction]
    
    init(source: Source) {
        self.source = source
        
        _transactions = Query(
            filter: SourceDetailsView.sourcePredicate(source.id),
            sort: \.date, order: .reverse
        )
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                Group {
                    Text("Total income:\n" + Formatter.shared.format(transactions.reduce(0) {$0 + $1.amount }))
                        .modifier(UrbanistFont(.regular, size: 24))
                        .foregroundColor(Color.text_color)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 24)
                    Divider()
                    
                    Text("History")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(UrbanistFont(.regular, size: 24))
                        .foregroundColor(Color.text_color)
                        .padding(.vertical, 12)
                }
                .padding(.horizontal, 12)
                
                List {
                    ForEach(transactions) { transaction in
                        TransactionCell(transaction: transaction)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 12, bottom: 12, trailing: 12))
                    .listRowBackground(Color.bg_color)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle(source.name)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private static func sourcePredicate(_ sourceID: UUID) -> Predicate<Transaction> {
        return #Predicate<Transaction> { transaction in
            transaction.source?.id == sourceID
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            SourceDetailsView(source: previewer.sources[0])
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
