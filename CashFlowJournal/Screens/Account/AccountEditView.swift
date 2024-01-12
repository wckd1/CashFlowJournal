//
//  AccountEditView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI
import SwiftData

struct AccountEditView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Query private var groups: [AccountGroup]
    
    @Bindable private var account: Account
    @State private var color: Color
    private let isCreation: Bool
    
    init(account: Account? = nil) {
        self.isCreation = account == nil
        
        let accountColorHEX = account?.color ?? Color.random().toHex()
        self._color = State(initialValue: Color(hex: accountColorHEX))
        self.account = account ?? Account(name: "", color: accountColorHEX)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                TextField("add_account_name_hint", text: $account.name)
                    .foregroundColor(Color.text_color)
                    .textFieldStyle(AppTextFieldStyle(left: "🏦"))
                
                if isCreation {
                    TextField("add_account_balance_hint", value: $account.balance, formatter: Formatter.shared.numberFormatter)
                        .textFieldStyle(AppTextFieldStyle(left: "💰", right: "€"))
                        .foregroundColor(Color.text_color)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                        .padding(.top, 6)
                }
                
                CustomColorPicker(hint: "add_account_color_hint", color: $color)
                    .padding(.top, 24)
                    .onChange(of: color) { _, value in
                        account.color = value.toHex()
                    }
                
                if groups.count > 0 {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("add_account_group_hint")
                            .modifier(UrbanistFont(.regular, size: 18))
                        
                        EntityPicker(items: groups, selectedItem: $account.group)
                    }
                }
                
                Spacer()
                
                Button {
                    saveAccount()
                } label: {
                    Text("save")
                        .modifier(UrbanistFont(.bold, size: 18))
                        .foregroundColor(Color.bg_color)
                        .padding(.vertical)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .background(account.name.isEmpty ? Color.gray : Color.primary_color)
                .cornerRadius(12)
                .disabled(account.name.isEmpty)
            }
            .padding()
        }
        .navigationTitle(account.name.isEmpty ? "add_account" : "edit_account")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func saveAccount() {
        modelContext.insert(account)
        dismiss()
    }
}

#Preview {
    do {
        let previewer = try Previewer()
        
        return NavigationView {
            AccountEditView()
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
