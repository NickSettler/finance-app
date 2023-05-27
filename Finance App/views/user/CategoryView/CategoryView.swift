//
//  CategoryView.swift
//  Finance App
//
//  Created by Никита Моисеев on 23.05.2023.
//

import SwiftUI
import SymbolPicker

struct CategoryView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var viewModel: CategoryViewViewModel
    
    init(category: Binding<Category>) {
        self._viewModel = StateObject(wrappedValue: CategoryViewViewModel(category: category))
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 12) {
                Button {
                    viewModel.isSymbolPickerPresent = true
                } label: {
                    Image(systemName: viewModel.editedCategory.icon)
                        .foregroundColor(Color.TextColorPrimary)
                        .padding(8)
                        .frame(
                            width: 44,
                            height: 44
                        )
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color.TextColorSecondary, lineWidth: 2)
                        }
                }
                .sheet(isPresented: $viewModel.isSymbolPickerPresent) {
                    SymbolPicker(symbol: $viewModel.editedCategory.icon)
                }
                
                TextField("Name", text: $viewModel.editedCategory.name)
                    .textFieldStyle(RoundedTextFieldStyle())
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .background(Color.BackgroundColor)
        .navigationTitle(viewModel.editedCategory.name)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Cancel")
            },
            trailing: Button {
                viewModel.save()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save")
            }
        )
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        var cat: Category = .init(id: "123", name: "Home", icon: "house.fill")
        
        NavigationView {
            CategoryView(category: .init(
                get: {
                    return cat
                },
                set: { category in
                    cat = category
                }))
        }
    }
}
