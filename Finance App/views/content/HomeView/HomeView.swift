//
//  HomeView2.swift
//  Finance App
//
//  Created by Никита Моисеев on 26.05.2023.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.colorScheme) var colorScheme
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    
    @StateObject private var viewModel = HomeViewModel()
    
    var openSettings: () -> ()
    
    var profile : some View {
        HStack(alignment: .center, spacing: 16) {
            AsyncImage(
                url: viewModel.photoUrl,
                content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                },
                placeholder: {
                    ProgressView()
                })
            .clipShape(Circle())
            .frame(width: 48)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello \(viewModel.userData?.first_name ?? "there")")
                    .font(.headline)
                    .foregroundColor(.TextColorPrimary)
                
                Text("Welcome back")
                    .font(.footnote)
                    .foregroundColor(.TextColorSecondary)
            }
            
            Spacer()
            
            Button {
                openSettings()
            } label: {
                Image(systemName: "gearshape")
            }
            .foregroundColor(.TextColorPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }
    
    var balance : some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Your balance")
                .font(.caption)
                .foregroundColor(.TextColorSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(viewModel.balance, format: .currency(code: "CZK"))
                .font(.largeTitle.bold())
                .kerning(1.3)
                .foregroundColor(.TextColorPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
    
    var actions : some View {
        HStack (alignment: .center) {
            action("plus", "Add") {
                viewModel.showAddTransactionSheet = true
            }
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $viewModel.showAddTransactionSheet) {
                NavigationView {
                    if #available(iOS 16.4, *) {
                        AddTransactionSheet(transaction: .init(
                            get: {
                                .init(amount: 0, category: unknownCategory, name: "", timestamp: .init(date: .now))
                            },
                            set: { transaction in
                                viewModel.createTransaction(transaction)
                            })
                        )
                        .presentationBackground(.thinMaterial)
                    } else {
                        AddTransactionSheet(transaction: .init(
                            get: {
                                .init(amount: 0, category: unknownCategory, name: "", timestamp: .init(date: .now))
                            },
                            set: { transaction in
                                viewModel.createTransaction(transaction)
                            })
                        )
                    }
                }
            }
            
            Divider()
                .frame(maxWidth: 1, maxHeight: 32)
                .overlay(Color.TextColorSecondary.opacity(0.3))
            
            action("pencil", "Balance") {
                viewModel.showUpdateBalanceSheet = true
            }
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $viewModel.showUpdateBalanceSheet) {
                NavigationView {
                    UpdateBalanceSheet()
                }
                .presentationDetents([.medium])
            }
            
            Divider()
                .frame(maxWidth: 1, maxHeight: 32)
                .overlay(Color.TextColorSecondary.opacity(0.3))
            
            action("swatchpalette", "Colors") {
                changeDarkMode(state: !isDarkMode)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.ColorPrimary)
                .shadow(color: .TextColorPrimary.opacity(0.08), radius: 8, y: 2)
        }
    }
    
    @ViewBuilder
    func action(
        _ icon: String,
        _ name: String,
        _ callback: @escaping () -> ()
    ) -> some View {
        Button(action: callback) {
            VStack(alignment: .center, spacing: 4) {
                Image(systemName: icon)
                Text("\(name)")
                    .font(.caption)
            }
            .foregroundColor(Color.TextColorPrimary)
        }
        .buttonStyle(.plain)
    }
    
    var operations : some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 8) {
                Text("Transactions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.TextColorPrimary)
            }
            
            if viewModel.recentTransactions.count > 0 {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(viewModel.recentSpent, format: .currency(code: "CZK"))
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Text("recently spent")
                        .font(.caption)
                }
                
                Divider()
                    .overlay(Color.TextColorSecondary.opacity(0.3))
                
                operationsList
            } else {
                Text("No recent transactions")
                    .foregroundColor(.TextColorSecondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.ColorPrimary)
                .shadow(color: .TextColorPrimary.opacity(0.08), radius: 8, y: 2)
        }
    }
    
    var operationsList : some View {
        VStack {
            ForEach(viewModel.recentTransactions, id: \.id) { transaction in
                TransactionListItem(transaction: transaction)
                    .padding(.bottom, 8)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    profile
                    
                    balance
                    
                    Divider()
                        .overlay(Color.TextColorSecondary.opacity(0.3))
                    
                    VStack(alignment: .center, spacing: 12) {
                        actions
                            .padding(.all, 16)
                            .padding(.top, 8)
                        
                        operations
                            .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
            }
            .background(Color.BackgroundColor)
        }
        .refreshable {
            viewModel.fetchTransactions()
            viewModel.fetchUserData()
        }
        .onAppear {
            viewModel.fetchTransactions()
            viewModel.fetchUserData()
        }
    }
    
    func changeDarkMode(state: Bool) {
        isDarkMode = state
        let window = UIApplication.shared.windows.first
        window?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(
            openSettings: {
                //
            }
        )
    }
}
