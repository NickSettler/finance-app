//
//  HomeView.swift
//  Finance App
//
//  Created by Никита Моисеев on 11.04.2023.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    var size: CGFloat
    
    @Environment(\.colorScheme) var colorScheme
    
    @State private var expandAccounts: Bool = false
    @StateObject private var viewModel = HomeViewViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: expandAccounts ? "chevron.left" : "line.3.horizontal")
                            .font(.title2)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    expandAccounts = false
                                }
                            }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Your balance")
                            .font(.caption)
                            .foregroundColor(colorScheme == .light ? .black : .white)
                            .opacity(expandAccounts ? 0 : 1)
                        
                        Text(expandAccounts ? "All Accounts" : "$295.4")
                            .font(.title2.bold())
                    }
                }
                .padding([.horizontal, .top], 15)
                
                CardsView()
                    .padding(.horizontal, 16)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        BottomContent()
                    }
                    .padding(.top, 32)
                    .padding([.horizontal, .bottom], 16)
                }
                .frame(maxWidth: .infinity)
                .background {
                    CustomCorner(corners: [.topLeft, .topRight], radius: 30)
                        .fill(colorScheme == .light ? .white : .black)
                        .ignoresSafeArea()
                        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -5)
                }
                .overlay {
                    CustomCorner(corners: [.topLeft, .topRight], radius: 30)
                        .fill(colorScheme == .light ? .white.opacity(0.92) : .black.opacity(0.92))
                        .opacity(expandAccounts ? 1 : 0)
                        .padding(.bottom, 16)
                        .shadow(color: colorScheme == .light ?.white.opacity(0.05) : .black.opacity(0.05), radius: 10, x: 0, y: 5)
                }
                .padding(.top, 20)
            }
            .background {
                Rectangle()
                    .fill(colorScheme == .light ? .black.opacity(0.05) : .white.opacity(0.1))
                    .ignoresSafeArea()
            }
            .overlayPreferenceValue(CardRectKey.self) { preferences in
                if let cardPreference = preferences["CardRect"] {
                    GeometryReader { proxy in
                        let cardRect = proxy[cardPreference]
                        
                        CardContent()
                            .frame(width: cardRect.width, height: expandAccounts ? nil : cardRect.height)
                            .offset(x: cardRect.minX, y: cardRect.minY)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.35)) {
                                    expandAccounts = true
                                }
                            }
                    }
                }
            }
            .onAppear {
                viewModel.handleAppear()
            }
        }
    }
    
    @ViewBuilder
    func CardContent() -> some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(allAccounts.reversed(), id: \.id) { account in
                    let index = CGFloat(allAccounts.firstIndex { account.id == $0.id } ?? 0)
                    let reversedIndex = CGFloat(allAccounts.count - 1) - index
                    
                    let displayingStackIndex = min(index, 2)
                    let displayScale = (displayingStackIndex / CGFloat(allAccounts.count)) * 0.15
                    
                    CardView(account)
                        .rotation3DEffect(.init(degrees: expandAccounts ? -15 :  0), axis: (x: 1, y: 0, z: 0), anchor: .top)
                        .frame(height: 200)
                        .scaleEffect(1 - (expandAccounts ? 0 : displayScale))
                        .offset(y: expandAccounts ? 0 : (displayingStackIndex * -15))
                        .offset(y: reversedIndex * -200)
                        .padding(.top, expandAccounts ? (reversedIndex == 0 ? 0 : 80) : 0)
                }
            }
            .padding(.top, 45)
            .padding(.bottom, CGFloat(allAccounts.count - 1) * -200)
        }
        .scrollDisabled(!expandAccounts)
    }
    
    @ViewBuilder
    func CardView(_ card: Account) -> some View {
        GeometryReader {
            let size = $0.size
            
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.blue.gradient)
                    .overlay(alignment: .top) {
                        VStack {
                            Text("\(card.name)")
                                .font(.title2.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .offset(y: 5)
                        }
                        .padding(20)
                        .foregroundColor(.black)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
    
    @ViewBuilder
    func CardsView() -> some View {
        Rectangle()
            .foregroundColor(.clear)
            .frame(height: expandAccounts ? .infinity : 245)
            .anchorPreference(key: CardRectKey.self, value: .bounds) { anchor in
                return ["CardRect": anchor]
            }
    }
    
    var popularCategoriesSection : some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Popular Categories")
                .font(.title3.bold())
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(viewModel.popularCategories, id: \.key) { category, count in
                        NavigationLink {
                            TransactionsView()
                        } label: {
                            VStack(alignment: .center, spacing: 4) {
                                Image(systemName: category.icon)
                                    .font(.title2)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 55, height: 55)
                                    .clipShape(Circle())
                                    .background {
                                        Circle()
                                            .strokeBorder(.gray, lineWidth: 1)
                                    }
                                
                                Text("\(category.name) (\(count))")
                                    .font(.caption)
                            }
                            .foregroundColor(colorScheme == .light ? .black : .white)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10 )
            }
            .padding(.horizontal, -16)
        }
    }
    
    @ViewBuilder
    func BottomContent() -> some View {
        VStack(spacing: 16) {
            if viewModel.popularCategories.count != 0 {
                popularCategoriesSection
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(size: 12)
    }
}
