//
//  AccountDetailsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 07.01.2024.
//

import SwiftUI
import SwiftData

struct AccountDetailsView: View {
    let account: Account
    
    @State private var selectedPeriod: PeriodFilter = .last7days
    
    private var incomeTransactions: [Transaction] {
        let transactions = account.transactions.filter { transaction in
            transaction.type == .income
        }
        
        guard let interval = selectedPeriod.periodDates() else { return transactions }
        
        return transactions.filter { transaction in
            transaction.date >= interval.start
            && transaction.date <= interval.end
        }
    }
    private var expenseTransactions: [Transaction] {
        let transactions = account.transactions.filter { transaction in
            transaction.type == .expense
            || transaction.type == .transfer
        }
        
        guard let interval = selectedPeriod.periodDates() else { return transactions }
        
        return transactions.filter { transaction in
            transaction.date >= interval.start
            && transaction.date <= interval.end
        }
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                if let group = account.group {
                    Text(group.name)
                        .modifier(UrbanistFont(.regular, size: 18))
                        .foregroundColor(Color.gray)
                        .padding(.horizontal)
                }
                
                Group {
                    HStack(alignment: .center, spacing: 12) {
                        Text("current \(Formatter.shared.format(account.balance))")
                            .modifier(UrbanistFont(.regular, size: 18))
                            .foregroundColor(Color.text_color)
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(Color(hex: account.color).opacity(0.8))
                            .cornerRadius(12)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("income \(Formatter.shared.format(incomeTransactions.reduce(0) {$0 + $1.amount }))")
                                .modifier(UrbanistFont(.regular, size: 18))
                                .foregroundColor(Color.text_color)
                            
                            Text("expense \(Formatter.shared.format(expenseTransactions.reduce(0) {$0 + $1.amount }))")
                                .modifier(UrbanistFont(.regular, size: 18))
                                .foregroundColor(Color.text_color)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Picker("picker_period_hint", selection: $selectedPeriod) {
                        ForEach(PeriodFilter.allCases, id: \.self) {
                            Text($0.title).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                TransactionsList(transactions: account.transactions.filter(period: selectedPeriod))
            }
        }
        .navigationTitle(account.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            NavigationLink { AccountEditView(account: account) } label: {
                Image(systemName: "gearshape")
                    .foregroundStyle(Color.primary_color)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            AccountDetailsView(account: previewer.accounts[3])
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
