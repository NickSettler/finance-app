//
//  UserMenu.swift
//  Finance App
//
//  Created by Никита Моисеев on 23.03.2023.
//

import SwiftUI

struct UserMenuView: View {
    @StateObject private var viewModel = UserMenuViewModel()
    
    var size: CGSize
    var safeArea: EdgeInsets
    
    var body: some View {
        NavigationView {
            ScrollViewReader { scrollProxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        HeaderView()
                            .zIndex(1000)
                        
                        VStack(alignment: .center, spacing: 24) {
                            VStack {
                                NavigationLink {
                                    HStack {}
                                } label: {
                                    Text("User data")
                                }
                                .buttonStyle(.borderedProminent)
                                
                                NavigationLink {
                                    AuthHistory()
                                } label: {
                                    Text("Auth history")
                                }
                                .buttonStyle(.borderedProminent)
                                
                                NavigationLink {
                                    CategoriesView()
                                } label: {
                                    Text("Custom categories")
                                }
                                .buttonStyle(.borderedProminent)
                            }
                        }
                    }
                    .id("SCROLLVIEW")
                    .background {
                        ScrollDetector { offset in
                            viewModel.offsetY = -offset
                        } onDraggingEnd: { offset, velocity in
                            let headerHeight = size.height * 0.3 + safeArea.top
                            let minimumHeaderHeight = 65 + safeArea.top
                            
                            let targetEnd = offset + (velocity * 45)
                            if targetEnd < (headerHeight - minimumHeaderHeight) && targetEnd > 0 {
                                withAnimation(.interactiveSpring(response: 0.55, dampingFraction: 0.65, blendDuration: 0.65)) {
                                    scrollProxy.scrollTo("SCROLLVIEW", anchor: .top)
                                }
                            }
                        }
                    }
                }
                .ignoresSafeArea(.all, edges: .top)
                .onAppear {
                    viewModel.handleAppear()
                }
            }
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        let headerHeight = size.height * 0.3 + safeArea.top
        let minimumHeaderHeight = 65 + safeArea.top
        
        let progress = max(min(-viewModel.offsetY / (headerHeight - minimumHeaderHeight), 1), 0)
        
        GeometryReader { _ in
            ZStack {
                Rectangle()
                    .fill(Color.pink)
                
                VStack (spacing: 16) {
                    GeometryReader {
                        let rect = $0.frame(in: .global)
                        let halfScaledHeight = (rect.height * 0.3) * 0.5
                        let midY = rect.midY
                        let bottomPadding: CGFloat = 16
                        let resizedOffsetY = (midY - (minimumHeaderHeight - halfScaledHeight - bottomPadding))
                        
                        AsyncImage(
                            url: viewModel.photoURL(),
                            content: { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            },
                            placeholder: {
                                ProgressView()
                            }
                        )
                        .frame(width: rect.width, height: rect.height)
                        .clipShape(Circle())
                        .scaleEffect(1 - (progress * 0.7), anchor: .leading)
                        .offset(x: -(rect.minX - 16) * progress, y: -resizedOffsetY * progress)
                    }
                    .frame(width: headerHeight * 0.5, height: headerHeight * 0.5)
                    
                    Text(viewModel.displayName())
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .scaleEffect(1 - (progress * 0.15))
                        .offset(y: -4.5 * progress)
                }
                .padding(.top, safeArea.top)
                .padding(.bottom, 16)
            }
            .frame(height: max(headerHeight + viewModel.offsetY, minimumHeaderHeight), alignment: .bottom)
            .offset(y: -viewModel.offsetY)
        }
        .frame(height: headerHeight)
    }
}

struct UserMenu_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            UserMenuView(size: $0.size, safeArea: $0.safeAreaInsets)
        }
    }
}
