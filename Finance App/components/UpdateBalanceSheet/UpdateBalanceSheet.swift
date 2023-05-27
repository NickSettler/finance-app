//
//  UpdateBalanceSheet.swift
//  Finance App
//
//  Created by Никита Моисеев on 27.05.2023.
//

import SwiftUI

struct UpdateBalanceSheet: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = UpdateBalanceSheetModel()
    
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
        UpdateBalanceSheet()
    }
}
