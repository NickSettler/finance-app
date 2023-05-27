//
//  MenuView.swift
//  Finance App
//
//  Created by Никита Моисеев on 22.03.2023.
//

import SwiftUI
import FirebaseAuth

struct MenuView: View {
    @StateObject private var viewModel = MenuViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Namespace private var animation
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            VStack(spacing: 0) {
                TabView(selection: $viewModel.activeTab) {
                    HomeView(openSettings: {
                        viewModel.activeTab = MenuTabModel.settings
                    })
                    .tag(MenuTabModel.home)
                    
                    TransactionsView()
                        .tag(MenuTabModel.transactions)
                    
                    UserMenuView(size: size, safeArea: safeArea)
                        .tag(MenuTabModel.settings)
                }
                .padding(.top, -20)
                .offset(y: 20)
                
                CustomTabBar()
                    .background(.clear)
            }
        }
    }
    
    @ViewBuilder
    func CustomTabBar(_ tint: Color = .Accent, _ inactiveTint: Color = .Accent) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(MenuTabModel.allCases, id: \.rawValue) {
                MenuTabItem(
                    tint: tint,
                    inactiveTint: inactiveTint,
                    tab: $0,
                    animation: animation,
                    activeTab: $viewModel.activeTab,
                    position: $viewModel.tabShapePosition
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background {
            MenuTabShape(midpoint: viewModel.tabShapePosition.x)
                .fill(Color.BackgroundColor)
                .ignoresSafeArea()
                .shadow(color: Color.ColorPrimary, radius: 5, x: 0, y: -5)
                .blur(radius: 2)
                .padding(.top, 24)
        }
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: viewModel.activeTab)
    }
}

struct MenuTabItem : View {
    var tint: Color
    var inactiveTint: Color
    var tab: MenuTabModel
    var animation: Namespace.ID
    
    @Binding var activeTab: MenuTabModel
    @Binding var position: CGPoint
    
    @State private var tabPosition: CGPoint = .zero
    
    var body: some View {
        VStack(spacing: 2) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .TextColorPrimary : .TextColorSecondary)
                .frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            
            Text(tab.rawValue)
                .font(.caption)
                .foregroundColor(activeTab == tab ? .TextColorPrimary : .TextColorSecondary)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .viewPosition{ rect in
            tabPosition.x = rect.midX
            
            if activeTab == tab {
                position.x = rect.midX
            }
        }
        .onTapGesture {
            activeTab = tab
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                position.x = tabPosition.x
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
