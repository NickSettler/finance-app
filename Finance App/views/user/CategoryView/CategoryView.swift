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
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
                
                Button {
                    viewModel.isColorPickerPresent = true
                } label: {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(viewModel.editedCategory.colorObject)
                        .padding(12)
                        .frame(
                            width: 44,
                            height: 44
                        )
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color.TextColorSecondary, lineWidth: 2)
                        }
                }
                .sheet(isPresented: $viewModel.isColorPickerPresent) {
                    NavigationView {
                        ColorPicker(
                            colors: categoryColors,
                            color: $viewModel.editedCategory.colorObject
                        )
                    }
                }
            }
            
            
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .background(Color.BackgroundColor)
        .navigationTitle(viewModel.editedCategory.name)
        .navigationBarBackButtonHidden(true)
        .gesture(
            DragGesture(minimumDistance: 20, coordinateSpace: .global)
                .onChanged { value in
                    guard value.startLocation.x < 20,
                          value.translation.width > 60 else {
                        return
                    }
                    presentationMode.wrappedValue.dismiss()
                }
        )
        .toolbar {
            ToolbarItemGroup(placement: .cancellationAction) {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Cancel")
                }
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    viewModel.save()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                }
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        var cat: Category = .init(
            id: "123",
            name: "Home",
            icon: "house.fill",
            color: 0x00FF00
        )
        
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
