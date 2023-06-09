//
//  UpdateBalanceSheet.swift
//  Finance App
//
//  Created by Nikita Moiseev on 27.05.2023.
//

import SwiftUI

struct UpdateBalanceSheet: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel: UpdateBalanceSheetModel
    
    init(balance: Double) {
        self._viewModel = StateObject(wrappedValue: UpdateBalanceSheetModel(balance: balance))
    }
    
    let amountFormatter: NumberFormatter = {
              let formatter = NumberFormatter()
              formatter.zeroSymbol = ""
              return formatter
         }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("New balance")
                .font(.headline)
                .foregroundColor(.TextColorPrimary)
            
            TextField("Balance", value: $viewModel.newBalanceValue, formatter: amountFormatter)
                .textFieldStyle(RoundedTextFieldStyle())
                .keyboardType(.decimalPad)
            
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
                presentationMode.wrappedValue.dismiss()
                viewModel.save()
            } label: {
                Text("Apply")
            }
        )
    }
}

struct UpdateBalanceSheet_Previews: PreviewProvider {
    static var previews: some View {
        UpdateBalanceSheet(balance: 4000)
    }
}
