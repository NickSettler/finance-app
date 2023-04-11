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
        List(viewModel.categories, id: \.id) { category in
            Text("\(category.name)")
        }
        .listStyle(.grouped)
        .background(.pink)
        .refreshable {
            Task {
                await viewModel.getUserCategories()
            }
        }
    }
    
    var body: some View {
        //        VStack {
        //            Text("Some text")
        //            Spacer()
        ////            list
        //        }
        NavigationView {
            if viewModel.categories.count == 0 {
                noCategories
            } else {
                list
            }
        }
        .navigationBarTitleDisplayMode(.inline)
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
