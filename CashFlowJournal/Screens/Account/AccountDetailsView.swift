//
//  AccountDetailsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 07.01.2024.
//

import SwiftUI
import SwiftData
import Charts

fileprivate struct ChartData: Identifiable {
    var id: String {
        "\(date)_\(type)"
    }
    
    let date: Date
    let type: TransactionType
    let amount: Float
}

struct AccountDetailsView: View {
    let account: Account
    private var sortedTransactions: [TransactionGroup] {
        account.transactions.groups()
    }
    @State private var incomeTransactions: [Transaction] = []
    @State private var expenseTransactions: [Transaction] = []
    @State private var selectedPeriod: PeriodFilter = .last7days
    
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
                            .padding(.vertical, 12)
                            .padding(.horizontal)
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
                        ForEach(PeriodFilter.accountCases, id: \.self) {
                            Text($0.title).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                if account.transactions.count < 1 {
                    ContentUnavailableView(
                        String(localized: "no_transactions_title"),
                        systemImage: "clipboard",
                        description: Text("no_transactions_description")
                    )
                } else {
                    List {
                        // Charts
                        Section {
                            Chart {
                                ForEach(chartData()) { barData in
                                    BarMark(
                                        x: .value("chart_date", barData.date, unit: .day),
                                        y: .value("chart_amount", barData.amount)
                                    )
                                    .foregroundStyle(barData.type == .income ? Color.income_color : Color.expense_color)
                                }
                            }
                            .chartYAxis(.hidden)
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                        .listRowBackground(Color.bg_color)
                        
                        // Transactions
                        ForEach(sortedTransactions) { group in
                            Section {
                                ForEach(group.transactions) { transaction in
                                    // TODO: Transaction details
                                    TransactionCell(transaction: transaction)
                                }
                            } header: {
                                Text(group.id)
                                    .modifier(UrbanistFont(.regular, size: 18))
                                    .foregroundColor(Color.gray)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                        .listRowBackground(Color.bg_color)
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
    
    private func reloadTransactions() {
        guard let interval = selectedPeriod.periodDates() else { return }
        
        incomeTransactions = account.transactions.filter { transaction in
            transaction.type == .income
            && transaction.date >= interval.start
            && transaction.date <= interval.end
        }
        
        expenseTransactions = account.transactions.filter { transaction in
            (transaction.type == .expense || transaction.type == .transfer)
            && transaction.date >= interval.start
            && transaction.date <= interval.end
        }
    }
    
    private func chartData() -> [ChartData] {
        // Income
        let incomeGroup = Dictionary(grouping: incomeTransactions) { $0.date }
        var incomeList = incomeGroup.map { k, v in
            ChartData(date: k, type: .income, amount: v.reduce(0) {$0 + $1.amount })
        }
        
        // Expenses
        let expenseGroup = Dictionary(grouping: expenseTransactions) { $0.date }
        let expensesList = expenseGroup.map { k, v in
            ChartData(date: k, type: .expense, amount: v.reduce(0) {$0 + $1.amount })
        }
        incomeList.append(contentsOf: expensesList)
        
        return incomeList
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
