//
//  CategoriesView.swift
//  Finance App
//
//  Created by Никита Моисеев on 29.03.2023.
//

import SwiftUI

struct CategoriesView: View {
    @StateObject private var viewModel = CategoriesViewModel()
    
    private var noCategories: some View {
        VStack(alignment: .center) {
            Text("You don't have any categories")
                .font(.headline)
            Spacer()
        }
    }
    
    private var list: some View {
        List($viewModel.categories.indices, id: \.self) { index in
            NavigationLink {
                CategoryView(category: .init(
                    get: {
                        return viewModel.categories[index]
                    },
                    set: { cat in
                        viewModel.saveCategory(category: cat)
                    }))
            } label: {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: viewModel.categories[index].icon)
                    
                    VStack(alignment: .leading) {
                        Text("\(viewModel.categories[index].name)")
                    }
                    
                    Spacer()
                }
            }
            .listRowBackground(Color.BackgroundColor)
            .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                    viewModel.deletingCategory = viewModel.categories[index]
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }
        }
        .listStyle(.grouped)
        .background(Color.BackgroundColor)
        .scrollContentBackground(.hidden)
        .confirmationDialog(
            "Are you sure?",
            isPresented: $viewModel.deletingPopoverShown
        ) {
            Button("Delete category", role: .destructive) {
                viewModel.deleteCategory()
            }
        } message: {
            Text("This action cannot be undone")
        }
        .refreshable {
            Task {
                await viewModel.getUserCategories()
            }
        }
    }
    
    var body: some View {
        ZStack {
            if viewModel.categories.count == 0 {
                noCategories
            } else {
                list
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.BackgroundColor)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button {
                //
            } label: {
                NavigationLink {
                    CategoryView(category: .init(get: {
                        .init(name: "", icon: "")
                    }, set: { cat in
                        viewModel.createCategory(category: cat)
                    }))
                } label: {
                    Text("Add")
                }
            }
        )
        .onAppear {
            Task {
                await viewModel.getUserCategories()
            }
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView()
    }
}
