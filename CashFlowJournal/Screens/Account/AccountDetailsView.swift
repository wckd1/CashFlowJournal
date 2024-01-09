//
//  AccountDetailsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 07.01.2024.
//

import SwiftUI
import SwiftData
import Charts

enum PeriodFilter: CaseIterable {
    case week
    case month
    
    var title: String {
        switch self {
        case .week: return String(localized: "week")
        case .month: return String(localized: "month")
        }
    }
}

struct ChartBarData: Identifiable {
    var id: String {
        "\(date)_\(type)"
    }
    
    let date: Date
    let type: TransactionType
    let amount: Float
}

struct AccountDetailsView: View {
    private let account: Account
    @Query private var transactions: [Transaction]
    @State private var incomeTransactions: [Transaction] = []
    @State private var expenseTransactions: [Transaction] = []
    @State private var selectedPeriod: PeriodFilter = .week
    
    init(account: Account) {
        self.account = account
        
        _transactions = Query(
            filter: AccountDetailsView.filterByAccount(account.id),
            sort: \.date, order: .reverse
        )
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack {
                Group {
                    HStack(alignment: .center, spacing: 12) {
                        Text("current \(Formatter.shared.format(account.balance))")
                            .modifier(UrbanistFont(.regular, size: 18))
                            .foregroundColor(Color.text_color)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 18)
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
                    
                    Picker("add_transaction_type_hint", selection: $selectedPeriod) {
                        ForEach(PeriodFilter.allCases, id: \.self) {
                            Text($0.title).tag($0)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal, 12)
                
                if transactions.count < 1 {
                    ContentUnavailableView(
                        String(localized: "no_accounts_title"),
                        systemImage: "clipboard",
                        description: Text("no_accounts_description")
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
                        Section {
                            ForEach(transactions) { transaction in
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
        .navigationTitle(account.name)
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func reloadTransactions() {
        guard let interval = periodDates() else { return }
        
        incomeTransactions = transactions.filter { transaction in
            transaction.type == .income
            && transaction.date >= interval.start
            && transaction.date <= interval.end
        }
        
        expenseTransactions = transactions.filter { transaction in
            transaction.type == .expense
            && transaction.date >= interval.start
            && transaction.date <= interval.end
        }
    }
    
    private func periodDates() -> DateInterval? {
        switch selectedPeriod {
        case .week:
            guard let startDay = Calendar.current.date(byAdding: .day, value: -7, to: Date()) else { return nil }
            return DateInterval(start: startDay, end: Date())
        case .month:
            guard let startDay = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else { return nil }
            return DateInterval(start: startDay, end: Date())
        }
    }
    
    private func chartData() -> [ChartBarData] {
        // Income
        let incomeGroup = Dictionary(grouping: incomeTransactions) { $0.date }
        var incomeList = incomeGroup.map { k, v in
            ChartBarData(date: k, type: .income, amount: v.reduce(0) {$0 + $1.amount })
        }
        
        // Expenses
        let expenseGroup = Dictionary(grouping: expenseTransactions) { $0.date }
        let expensesList = expenseGroup.map { k, v in
            ChartBarData(date: k, type: .expense, amount: v.reduce(0) {$0 + $1.amount })
        }
        incomeList.append(contentsOf: expensesList)
        
        return incomeList
    }
    
    // Predicates
    private static func filterByAccount(_ accountID: UUID) -> Predicate<Transaction> {
        return #Predicate<Transaction> { transaction in
            transaction.account.id == accountID
        }
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            AccountDetailsView(account: previewer.accounts[1])
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
