//
//  AddAccountView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 05.01.2024.
//

import SwiftUI

struct AddAccountView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @Bindable private var account = Account(name: "", color: Color.primary_color.toHex())
    @State private var color = Color.random()
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.bg_color.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 24) {
                
                TextField("add_account_name_hint", text: $account.name)
                    .foregroundColor(Color.text_color)
                    .textFieldStyle(AppTextFieldStyle(left: "🏦"))
                
                TextField("add_account_balance_hint", value: $account.balance, formatter: Formatter.shared.numberFormatter)
                    .textFieldStyle(AppTextFieldStyle(left: "💰", right: "€"))
                    .foregroundColor(Color.text_color)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .padding(.top, 6)
                
                ColorPicker("add_account_color_hint", selection: $color, supportsOpacity: false)
                    .modifier(UrbanistFont(.regular, size: 18))
                    .foregroundStyle(Color.text_color)
                    .padding(.top, 24)
                    .onChange(of: color) { _, value in
                        account.color = value.toHex()
                    }
                
                Spacer()
                
                Button {
                    saveAccount()
                } label: {
                    Text("save")
                        .modifier(UrbanistFont(.bold, size: 18))
                        .foregroundColor(Color.bg_color)
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .background(account.name.isEmpty ? Color.gray : Color.primary_color)
                .cornerRadius(12)
                .padding(.top, 25)
                .disabled(account.name.isEmpty)
            }
            .padding(24)
        }
        .navigationTitle("add_account")
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
            AddAccountView()
                .modelContainer(previewer.container)
        }
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
