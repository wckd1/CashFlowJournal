//
//  SettingsView.swift
//  CashFlowJournal
//
//  Created by Роман Коробейников on 17.01.2024.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage(UserDefaults.usernameKey)
    private var username: String = "Roman"
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topLeading) {
                Color.bg_color.ignoresSafeArea()
                
                VStack(alignment: .leading) {
                    Text(username)
                        .modifier(UrbanistFont(.regular, size: 24))
                        .foregroundStyle(Color.text_color)
                    
                    VStack(alignment: .leading, spacing: 18) {
                        NavigationLink {
                            AccountsView()
                        } label: {
                            HStack(alignment: .center, spacing: 12) {
                                Text("🏦")
                                
                                Text("dashboard_accounts")
                                    .modifier(UrbanistFont(.regular, size: 18))
                                    .foregroundStyle(Color.text_color)
                            }
                        }
                        
                        NavigationLink {
                            SourcesView()
                        } label: {
                            HStack(alignment: .center, spacing: 12) {
                                Text("💸")
                                
                                Text("dashboard_sources")
                                    .modifier(UrbanistFont(.regular, size: 18))
                                    .foregroundStyle(Color.text_color)
                            }
                        }
                        
                        NavigationLink {
                            CategoriesView()
                        } label: {
                            HStack(alignment: .center, spacing: 12) {
                                Text("🏷️")
                                
                                Text("dashboard_categories")
                                    .modifier(UrbanistFont(.regular, size: 18))
                                    .foregroundStyle(Color.text_color)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top)
                }
                .padding()
            }
        }
    }
}

#Preview {
    SettingsView()
}
