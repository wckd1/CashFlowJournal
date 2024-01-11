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
    @Query private var categories: [Category]
    
    @State private var transactionType: TransactionType = .income
    @State private var title: String = ""
    @State private var amount: Float = 0
    @State private var selectedAccount: Account?
    @State private var selectedSource: Source?
    @State private var selectedCategory: Category?
    @State private var originAccount: Account?
    
    @State private var transactionError: String?
    @State private var isValid: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack {
                Form {
                    Section {
                        // Type
                        Picker("add_transaction_type_hint", selection: $transactionType) {
                            ForEach(TransactionType.allCases, id: \.self) {
                                Text($0.title).tag($0)
                            }
                        }
                        .pickerStyle(.segmented)
                        .padding(.vertical, 18)
                        .onChange(of: transactionType) { _, _ in
                            validate()
                        }
                        
                        // Title
                        TextField("add_transaction_hint", text: $title)
                            .foregroundStyle(Color.text_color)
                            .textFieldStyle(AppTextFieldStyle(left: "📝"))
                            .padding(.bottom, 18)
                            .onChange(of: title) { _, _ in
                                validate()
                            }
                        
                        // Amount
                        TextField("add_transaction_amount_hint", value: $amount, formatter: Formatter.shared.numberFormatter)
                            .textFieldStyle(AppTextFieldStyle(left: "💵", right: "€"))
                            .foregroundColor(Color.text_color)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .padding(.bottom, 24)
                            .onChange(of: amount) { _, value in
                                validate()
                            }
                    }
                    .listRowBackground(Color.bg_color)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                    
                    switch transactionType {
                    case .income:
                        // Source
                        Section(header: Text("add_transaction_source_hint")) {
                            TransactionEntityPicker(items: sources, selectedItem: $selectedSource)
                                .onChange(of: selectedSource) { _, _ in
                                    validate()
                                }
                        }
                        .listRowBackground(Color.bg_color)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                    case .expense:
                        // Category
                        Section(header: Text("add_transaction_category_hint")) {
                            TransactionEntityPicker(items: categories, selectedItem: $selectedCategory)
                                .onChange(of: selectedSource) { _, _ in
                                    validate()
                                }
                        }
                        .listRowBackground(Color.bg_color)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                    case .transfer:
                        // Account
                        Section(header: Text("add_transaction_account_hint")) {
                            TransactionEntityPicker(items: accounts, selectedItem: $selectedAccount)
                                .onChange(of: selectedAccount) { _, _ in
                                    validate()
                                }
                        }
                        .listRowBackground(Color.bg_color)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                    }
                    
                    // Account
                    Section(header: Text("add_transaction_origin_account_hint")) {
                        TransactionEntityPicker(items: accounts, selectedItem: $originAccount)
                            .onChange(of: originAccount) { _, _ in
                                validate()
                            }
                    }
                    .listRowBackground(Color.bg_color)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                }
                .background(Color.bg_color)
                .scrollContentBackground(.hidden)
                
//                Spacer()
                
                // Error
                if let transactionError {
                    Text(transactionError)
                        .foregroundStyle(Color.error_color)
                }
                
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
                .background(isValid ? Color.primary_color : Color.gray)
                .cornerRadius(12)
                .padding(.horizontal, 24)
                .padding(.bottom, 6)
                .disabled(!isValid)
            }
        }
        .navigationTitle("add_transaction")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func validate() {
        var isValidatioPassed = true
        transactionError = nil
        
        if title.isEmpty { isValidatioPassed = false }
        if Float(amount) <= 0  { isValidatioPassed = false }
        
        if transactionType == .income {
            if selectedSource == nil {
                isValidatioPassed = false
            }
        } else {
            if let account = originAccount, account.balance < amount {
                transactionError = String(localized: "add_transaction_account_funds_error")
                isValidatioPassed = false
            }
            
            if transactionType == .expense, selectedCategory == nil {
                isValidatioPassed = false
            }
            
            if transactionType == .transfer, selectedAccount == nil {
                isValidatioPassed = false
            }
        }
        
        if originAccount == nil {
            isValidatioPassed = false
        }
        
        isValid = isValidatioPassed
    }
    
    private func saveTransaction() {
        do {
            try modelContext.transaction {
                // Save transaction
                let transaction = Transaction(
                    title: title,
                    amount: amount,
                    type: transactionType,
                    source: transactionType == .income ? selectedSource! : nil,
                    category: transactionType == .expense ? selectedCategory! : nil,
                    account: transactionType == .transfer ? selectedAccount! : nil,
                    originAccount: originAccount!
                )
                modelContext.insert(transaction)
                
                switch transaction.type {
                case .income:
                    // Update source's transactions
                    selectedSource?.transactions.append(transaction)
                    // Update account balance
                    originAccount?.balance += transaction.amount
                case .expense:
                    // Update category's transactions
                    selectedCategory?.transactions.append(transaction)
                    // Update account balance
                    originAccount?.balance -= transaction.amount
                case .transfer:
                    // Update accounts transactions
                    selectedAccount?.transactions.append(transaction)
                    // Update account balance
                    selectedAccount?.balance += transaction.amount
                    originAccount?.balance -= transaction.amount
                }
                
                originAccount?.transactions.append(transaction)
            }
            
            modelContext.processPendingChanges()
            
            dismiss()
        } catch let error {
            print("Error saving transaction: \(error.localizedDescription)")
        }
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
