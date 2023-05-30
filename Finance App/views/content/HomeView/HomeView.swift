//
//  HomeView2.swift
//  Finance App
//
//  Created by Nikita Moiseev on 26.05.2023.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("isDarkMode") var isDarkMode: Bool = true
    @AppStorage("collapseCategoriesChart") var collapseCategoriesChart: Bool = false
    @AppStorage("categoriesChartMode") var categoriesChartMode: Bool = false
    
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
            
            Divider()
                .frame(maxWidth: 1, maxHeight: 32)
                .overlay(Color.TextColorSecondary.opacity(0.3))
            
            action("pencil", "Balance") {
                viewModel.showUpdateBalanceSheet = true
            }
            .frame(maxWidth: .infinity)
            .sheet(isPresented: $viewModel.showUpdateBalanceSheet) {
                NavigationView {
                    UpdateBalanceSheet(balance: viewModel.balance)
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
    
    var chart : some View {
        return VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Menu() {
                    Picker("Chart", selection: $categoriesChartMode) {
                        Text("Income")
                            .tag(true)
                        
                        Text("Expense")
                            .tag(false)
                    }
                } label: {
                    HStack(alignment: .center, spacing: 4) {
                        Text("\(categoriesChartMode ? "Income" : "Expense") chart")
                            .font(.headline)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                    }
                    .fontWeight(.semibold)
                    .foregroundColor(.TextColorPrimary)
                }
                
                Spacer()
                
                Button {
                    self.collapseCategoriesChart.toggle()
                } label: {
                    Image(systemName: !collapseCategoriesChart ? "eye.fill" : "eye.slash.fill")
                }
            }
            .padding(.bottom, collapseCategoriesChart ? 0 : 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if viewModel.chartValues.count == 0 {
                Text("No \(categoriesChartMode ? "incomes" : "expenses") found")
                    .foregroundColor(.TextColorSecondary)
                    .frame(maxWidth: .infinity, maxHeight: collapseCategoriesChart ? 0 : .none, alignment: .center)
                    .if(collapseCategoriesChart) { view in
                        view.clipped()
                    }
            } else {
                VStack(alignment: .center) {
                    PieChartView(
                        values: Array(viewModel.chartValues.map { $0.value }),
                        colors: viewModel.chartValues.map { $0.key.colorObject },
                        names: viewModel.chartValues.map { $0.key.name },
                        size: 200
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: collapseCategoriesChart ? 0 : .none, alignment: .center)
                .if(collapseCategoriesChart) { view in
                    view.clipped()
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .clipped()
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.ColorPrimary)
                .shadow(color: .TextColorPrimary.opacity(0.08), radius: 8, y: 2)
        }
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
                        .foregroundColor(.TextColorPrimary)
                    
                    Text("recently spent")
                        .font(.caption)
                        .foregroundColor(.TextColorPrimary)
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
            ForEach($viewModel.recentTransactions, id: \.id) { $transaction in
                NavigationLink {
                    TransanctionView(transaction: $transaction)
                } label: {
                    TransactionListItem(
                        transaction: transaction,
                        categories: viewModel.categories
                    )
                    .padding(.bottom, 8)
                }
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
                    
                    VStack(alignment: .center, spacing: 24) {
                        actions
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                        
                        if viewModel.transactions.count > 0 {
                            chart
                                .padding(.horizontal, 16)
                        }
                        
                        operations
                            .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 20)
                    
                    Spacer()
                }
            }
            .background(Color.BackgroundColor)
            .refreshable {
                viewModel.fetchCategories()
                viewModel.fetchTransactions()
                viewModel.fetchUserData()
            }
        }
        .sheet(isPresented: $viewModel.showAddTransactionSheet) {
            NavigationView {
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
        .onAppear {
            viewModel.fetchCategories()
            viewModel.fetchTransactions()
            viewModel.fetchUserData()
        }
    }
    
    func changeDarkMode(state: Bool) {
        withAnimation(.easeInOut(duration: 0.5)) {
            isDarkMode.toggle()
        }
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
