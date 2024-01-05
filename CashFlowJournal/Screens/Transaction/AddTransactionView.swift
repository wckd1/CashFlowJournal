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
    
    @State private var type: Int = 0
    @State private var title: String = ""
    @State private var amount: Float = 0
    @State private var selectedAccount: Account?
    @State private var selectedSource: Source?
    @State private var selectedCategory: Category?
    
    @State private var transactionError: String?
    @State private var isValid: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 12) {
                // Type
                Picker("add_transaction_type_hint", selection: $type) {
                    Text("income").tag(0)
                    Text("expense").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.bottom, 18)
                .onChange(of: type) { _, _ in
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
                    .onChange(of: amount) { _, _ in
                        validate()
                    }
                
                // Source
                if type == 0 {
                    TransactionSourcePicker(sources: sources, selectedSource: $selectedSource)
                    .onChange(of: selectedSource) { _, _ in
                        validate()
                    }
                } else {
                    // Category
                    TransactionCategoryPicker(categories: categories, selectedCategory: $selectedCategory)
                    .onChange(of: selectedCategory) { _, _ in
                        validate()
                    }
                }
                
                // Account
                TransactionAccountPicker(accounts: accounts, selectedAccount: $selectedAccount)
                .onChange(of: selectedAccount) { _, _ in
                    validate()
                }
                
                Spacer()
                
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
                .padding(.top, 25)
                .disabled(!isValid)
            }
            .padding(24)
        }
        .navigationTitle("add_transaction")
    }
    
    private func validate() {
        var isValidatioPassed = true
        transactionError = nil
        
        if title.isEmpty { isValidatioPassed = false }
        if amount <= 0 { isValidatioPassed = false }
        
        if type == 0, selectedSource == nil {
            isValidatioPassed = false
        }
        if type == 1 {
            if selectedCategory == nil {
                isValidatioPassed = false
            }
            if let account = selectedAccount, account.balance < amount {
                transactionError = String(localized: "add_transaction_account_funds_error")
                isValidatioPassed = false
            }
        }
        
        if selectedAccount == nil {
            isValidatioPassed = false
        }
        
        isValid = isValidatioPassed
    }
    
    private func checkAccountBalance() {
        if type == 1, let selectedAccount, selectedAccount.balance < amount {
            transactionError = String(localized: "add_transaction_account_funds_error")
        } else {
            transactionError = nil
        }
    }
    
    private func saveTransaction() {
        // Save transaction
        let transactionType: TransactionType = type == 0
        ? .income
        : .expense
        
        let transaction = Transaction(
            title: title,
            amount: amount,
            type: transactionType,
            source: transactionType == .income ? selectedSource! : nil,
            category: transactionType == .expense ? selectedCategory! : nil,
            account: selectedAccount!
        )
        modelContext.insert(transaction)
        
        // Update account balance
        var transactionAmount = amount
        if transactionType == .expense { transactionAmount *= -1 }
        selectedAccount!.balance += transactionAmount
        
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
