//
//  TransactionsView.swift
//  Finance App
//
//  Created by Никита Моисеев on 24.05.2023.
//

import SwiftUI

struct TransactionsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject private var viewModel = TransactionsViewViewModel()
    
    var noTransactions: some View {
        VStack(alignment: .center) {
            Text("No transactions found")
                .frame(maxWidth: .infinity)
                .font(.title2)
                .foregroundColor(.gray)
            
            Spacer()
        }
    }
    
    var filterSheet: some View {
        NavigationView {
            VStack(spacing: 12) {
                DatePicker(
                    selection: $viewModel.afterDate,
                    in: ...Date.now,
                    displayedComponents: .date
                ) {
                    Text("After: ")
                        .font(.headline)
                        .foregroundColor(.TextColorPrimary)
                }
                .onChange(of: viewModel.afterDate) { value in
                    viewModel.beforeDate = max(
                        value,
                        viewModel.afterDate
                    )
                }
                
                DatePicker(
                    selection: $viewModel.beforeDate,
                    in: ...Date.now,
                    displayedComponents: .date
                ) {
                    Text("Before: ")
                        .font(.headline)
                        .foregroundColor(.TextColorPrimary)
                }
                .onChange(of: viewModel.beforeDate) { value in
                    viewModel.afterDate = min(
                        value,
                        viewModel.beforeDate
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Direction")
                        .font(.headline)
                        .foregroundColor(.TextColorPrimary)
                    
                    Picker("Direction", selection: $viewModel.direction) {
                        Text("All")
                            .tag(0)
                        
                        Text("Exponse")
                            .tag(-1)
                        
                        Text("Income")
                            .tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Categories")
                        .font(.headline)
                        .foregroundColor(.TextColorPrimary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .center, spacing: 20) {
                            ForEach(viewModel.categories, id: \.id) { category in
                                CategoryCircleItem(
                                    category: category,
                                    selected: viewModel.selectedCategories.contains(category)
                                )
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        viewModel.selectedCategories.toggle(category)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.horizontal, -16)
                }
                
                Spacer()
                Button {
                    viewModel.resetFilters()
                } label: {
                    HStack(alignment: .center, spacing: 8) {
                        Image(systemName: "arrow.counterclockwise")
                        
                        Text("Reset filters")
                    }
                }
                .disabled(!viewModel.canReset)
            }
            .padding(16)
            .background(Color.BackgroundColor)
            .navigationBarItems(
                trailing: Button {
                    viewModel.isFilterSheetPresent = false
                } label: {
                    Text("Apply")
                }
            )
        }
    }
    
    var transactionsList: some View {
        List(
            $viewModel.filteredTransactions,
            id: \.id
        ) { $transanction in
            NavigationLink {
                TransanctionView(transaction: $transanction)
            } label: {
                TransactionListItem(
                    transaction: transanction,
                    categories: viewModel.categories
                )
            }
            .swipeActions {
                Button(role: .destructive) {
                    viewModel.deletingTransaction = transanction
                } label: {
                    Label("Delete transaction", systemImage: "trash.fill")
                }
            }
            .listRowBackground(Color.BackgroundColor)
            .background(Color.BackgroundColor)
        }
        .listStyle(.grouped)
        .background(Color.BackgroundColor)
        .scrollContentBackground(.hidden)
        .confirmationDialog(
            "Are you sure?",
            isPresented: $viewModel.isDeletingModalShown
        ) {
            Button("Delete transaction", role: .destructive) {
                viewModel.deleteTransaction()
            }
        } message: {
            Text("This action cannot be undone")
        }
    }
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.isSortingDesc.toggle()
                        }
                    } label: {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "chevron.down")
                                .rotationEffect(.degrees(viewModel.isSortingDesc ? 0 : 180))
                            
                            Text(viewModel.isSortingDesc ? "Descending" : "Ascending")
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.isFilterSheetPresent = true
                    } label: {
                        HStack(alignment: .center, spacing: 8) {
                            Image(systemName: "line.3.horizontal.decrease")
                            
                            Text("Filter")
                            
                            if viewModel.canReset {
                                Circle()
                                    .fill(Color.ColorPrimary)
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(12)
                
                if viewModel.filteredTransactions.count == 0 {
                    List {
                        noTransactions
                            .listRowSeparatorTint(.clear)
                            .listRowBackground(Color.BackgroundColor)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    .background(Color.BackgroundColor)
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .refreshable {
                        viewModel.fetchCategories()
                        viewModel.fetchTransactions()
                    }
                } else {
                    transactionsList
                        .refreshable {
                            viewModel.fetchCategories()
                            viewModel.fetchTransactions()
                        }
                }
            }
            .background(Color.BackgroundColor)
            .onAppear {
                viewModel.fetchCategories()
                viewModel.fetchTransactions()
            }
            .sheet(isPresented: $viewModel.isFilterSheetPresent) {
                filterSheet
            }
        }
    }
}

struct TransactionsView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionsView()
    }
}
