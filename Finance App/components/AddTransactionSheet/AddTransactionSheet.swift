//
//  AddTransactionSheet.swift
//  Finance App
//
//  Created by Никита Моисеев on 27.05.2023.
//

import SwiftUI

struct AddTransactionSheet: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: AddTransactionSheetModel
    
    init(transaction: Binding<Transaction>) {
        self._viewModel = StateObject(wrappedValue: AddTransactionSheetModel(transaction: transaction))
    }
    
    let amountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.zeroSymbol = ""
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Name")
                    .font(.headline)
                    .foregroundColor(.TextColorPrimary)
                
                TextField("Name", text: $viewModel.currentTransaction.name)
                    .textFieldStyle(RoundedTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Category")
                    .font(.headline)
                    .foregroundColor(.TextColorPrimary)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 20) {
                        ForEach(viewModel.categories, id: \.id) { category in
                            CategoryCircleItem(
                                category: category,
                                selected: viewModel.category == category
                            )
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    if viewModel.category == category {
                                        viewModel.updateCategory(category: unknownCategory)
                                    } else {
                                        viewModel.updateCategory(category: category)
                                    }
                                }
                            }
                        }
                        
                        CategoryCircleItem(
                            category: .init(name: "New", icon: "plus")
                        )
                        .onTapGesture {
                            viewModel.addNewCategorySheetPresent = true
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.horizontal, -16)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                Text("Amount")
                    .font(.headline)
                    .foregroundColor(.TextColorPrimary)
                
                TextField("Amount", value: $viewModel.currentTransaction.amount, formatter: amountFormatter)
                    .textFieldStyle(RoundedTextFieldStyle())
                    .keyboardType(.decimalPad)
            }
            
            Picker("Direction", selection: $viewModel.direction) {
                Text("Expense")
                    .tag(false)
                
                Text("Income")
                    .tag(true)
            }
            .pickerStyle(.segmented)
            
            DatePicker(
                selection: .init(get: {
                    return $viewModel.currentTransaction.timestamp.wrappedValue.dateValue()
                }, set: { date in
                    viewModel.currentTransaction.timestamp = .init(date: date)
                }),
                in: ...Date.now,
                displayedComponents: .date
            ) {
                Text("Date")
                    .font(.headline)
                    .foregroundColor(.TextColorPrimary)
            }
            
            Button {
                viewModel.save()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Add")
                    .font(.headline)
                    .padding(.vertical, 4)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .navigationBarItems(
            leading: Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Close")
            },
            trailing: Button {
                viewModel.save()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Create")
            }
        )
        .sheet(isPresented: $viewModel.addNewCategorySheetPresent) {
            NavigationView {
                CategoryView(category: .init(
                    get: {
                        .init(name: "", icon: "")
                    }, set: { cat in
                        viewModel.createCategory(category: cat)
                    }
                ))
            }
        }
        .onAppear {
            viewModel.fetchCategories()
        }
    }
}

struct AddTransactionSheet_Previews: PreviewProvider {
    static var previews: some View {
        var transaction: Transaction = .init(
            id: "123",
            amount: 12,
            category: unknownCategory,
            name: "abc",
            timestamp: .init(date: .now),
            notes: ""
        )
        
        AddTransactionSheet(transaction: .init(
            get: {
                return transaction
            }, set: { trans in
                transaction = trans
            }
        ))
    }
}
