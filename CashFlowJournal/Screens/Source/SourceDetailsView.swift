//
//  SourceDetailsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 07.01.2024.
//

import SwiftUI
import SwiftData

struct SourceDetailsView: View {
    let source: Source
    @State private var selectedPeriod: PeriodFilter = .month
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack {
                Group {
                    Text("Total income:\n" + Formatter.shared.format(source.transactions.reduce(0) { $0 + $1.amount }))
                        .modifier(UrbanistFont(.regular, size: 24))
                        .foregroundColor(Color.text_color)
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 24)
                    
                    Picker("add_transaction_type_hint", selection: $selectedPeriod) {
                        ForEach(PeriodFilter.incomeCases , id: \.self) {
                            Text($0.title).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal, 12)
                
                TransactionsList(transactions: source.transactions.filter(period: selectedPeriod))
            }
        }
        .navigationTitle(source.name)
        .navigationBarTitleDisplayMode(.large)
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
