//
//  AddTransactionView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 04.01.2024.
//

import SwiftUI
import SwiftData

struct AddTransactionView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query private var accounts: [Account]
    @Query private var sources: [Source]
    
    @State private var type: Int = 0
    @State private var title: String = ""
    @State private var amount: Float = 0
    @State private var selectedAccount: Account?
    @State private var selectedSource: Source?
    @State private var selectedCategory: String? = ""
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                // Type
                Picker("add_transaction_type_hint", selection: $type) {
                    Text("Income").tag(0)
                    Text("Expense").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 18)
                
                // Title
                TextField("add_transaction_hint", text: $title)
                    .foregroundStyle(Color.text_color)
                    .textFieldStyle(AppTextFieldStyle(left: "📝"))
                    .padding(.bottom, 18)
                
                // Amount
                TextField("add_transaction_amount_hint", value: $amount, formatter: Formatter.shared.numberFormatter)
                    .textFieldStyle(AppTextFieldStyle(left: "💵", right: "€"))
                    .foregroundColor(Color.text_color)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .padding(.bottom, 24)
                    .onChange(of: amount) { _, value in
                        type = value < 0 ? 1 : 0
                    }
                
                if type == 0 {
                    Text("add_transaction_source_hint")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(UrbanistFont(.regular, size: 18))
                        .foregroundStyle(Color.text_color)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(sources) { source in
                                Button {
                                    selectedSource = source
                                } label: {
                                    HStack {
                                        Image(systemName: source.icon)
                                            .font(.subheadline)
                                            .foregroundStyle(Color.text_color)
                                        Text(source.name)
                                            .foregroundStyle(Color.text_color)
                                    }
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 18)
                                .background(selectedSource == source ? Color(hex: source.color) : Color.gray)
                                .cornerRadius(6)
                            }
                        }
                    }
                } else {
                    // Category
                    Text("add_transaction_category_hint")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .modifier(UrbanistFont(.regular, size: 18))
                        .foregroundStyle(Color.text_color)
                }
                
                // Account
                Text("add_transaction_account_hint")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundStyle(Color.text_color)
                    .padding(.top, 18)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(accounts) { account in
                            Button {
                                selectedAccount = account
                            } label: {
                                Text(account.name)
                                    .foregroundStyle(Color.text_color)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 18)
                            .background(selectedAccount == account ? Color.primary_color : Color.gray)
                            .cornerRadius(6)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    saveTransaction()
                } label: {
                    Text("save")
                        .modifier(UrbanistFont(.bold, size: 18))
                        .foregroundColor(Color.bg_color)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .background(validate() ? Color.primary_color : Color.gray)
                .cornerRadius(12)
                .padding(.top, 25)
                .disabled(!validate())
            }
            .padding(24)
        }
        .navigationTitle("add_transaction")
    }
    
    private func validate() -> Bool {
        guard !title.isEmpty else { return false }
        guard amount > 0 else { return false }
        guard selectedAccount != nil else { return false }
        if type == 0, selectedSource == nil {
            return false
        }
        if type == 1, selectedCategory == nil {
            return false
        }
        return true
    }
    
    private func saveTransaction() {
        // TODO: Add check for sufficent ammount on selected account
        // TODO: Change account's balance
        
        let transactionType: TransactionType = type == 0
            ? .income
            : .expense
        
        let transaction = Transaction(
            title: title,
            amount: amount,
            type: transactionType,
            source: transactionType == .income ? selectedSource : nil,
            account: selectedAccount!
        )
        modelContext.insert(transaction)
        dismiss()
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            AddTransactionView()
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
