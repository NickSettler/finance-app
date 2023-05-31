//
//  UserDataView.swift
//  Finance App
//
//  Created by Nikita Moiseev on 31.05.2023.
//

import SwiftUI
import PhotosUI

struct UserDataView: View {
    @StateObject private var viewModel = UserDataViewModel()
    
    var image: some View {
        AsyncImage(
            url: viewModel.photoUrl,
            content: { image in
                image
                    .resizable()
                    .scaledToFit()
            },
            placeholder: {
                ProgressView()
            })
        
    }
    
    var profileImage: some View {
        image
            .clipShape(Circle())
            .frame(width: 64)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.isImageFullscreen.toggle()
                }
            }
            .fullScreenCover(isPresented: $viewModel.isImageFullscreen) {
                ZStack {
                    image
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay(alignment: .topTrailing) {
                    Button {
                        viewModel.isImageFullscreen = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.TextColorPrimary)
                            .padding(8)
                            .background(Color.TextColorSecondary.opacity(0.24))
                            .clipShape(Circle())
                    }
                    .padding(12)
                    .buttonStyle(.plain)
                }
            }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            profileImage
                .padding(.bottom, 24)
            
            VStack(alignment: .leading, spacing: viewModel.editMode ? 12 : 38) {
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text("First name")
                        .font(.headline)
                    
                    if viewModel.editMode {
                        TextField("First name", text: $viewModel.editedUserData.first_name)
                            .textFieldStyle(RoundedTextFieldStyle())
                            .textInputAutocapitalization(.words)
                            .autocorrectionDisabled(true)
                    } else {
                        Text(viewModel.userData.first_name.isEmpty ? "not set" : viewModel.userData.first_name)
                            .italic(viewModel.userData.first_name.isEmpty)
                            .foregroundColor(viewModel.userData.first_name.isEmpty ? .TextColorSecondary : .TextColorPrimary)
                            .padding(.leading, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                HStack(alignment: .firstTextBaseline, spacing: 12) {
                    Text("Last name")
                        .font(.headline)
                    
                    if viewModel.editMode {
                        TextField("Last name", text: $viewModel.editedUserData.last_name)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.words)
                            .textFieldStyle(RoundedTextFieldStyle())
                    } else {
                        Text(viewModel.userData.last_name.isEmpty ? "not set" : viewModel.userData.last_name)
                            .italic(viewModel.userData.first_name.isEmpty)
                            .foregroundColor(viewModel.userData.first_name.isEmpty ? .TextColorSecondary : .TextColorPrimary)
                            .padding(.leading, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .offset(y: viewModel.editMode ? -13 : 0)
            .frame(maxWidth: .infinity)
            
            Spacer()
        }
        .padding(16)
        .background(Color.BackgroundColor)
        .navigationBarBackButtonHidden(viewModel.editMode)
        .toolbar {
            if viewModel.editMode {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            viewModel.dismissChanges()
                        }
                    } label: {
                        Text("Dismiss")
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        if viewModel.editMode {
                            viewModel.applyChanges()
                        } else {
                            viewModel.editMode = true
                        }
                    }
                } label: {
                    Text(viewModel.editMode ? "Apply" : "Edit")
                }
                .disabled(viewModel.editMode && !viewModel.dataChanged)
            }
        }
        .onAppear {
            viewModel.fetchUserData()
        }
    }
}

struct UserDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserDataView()
        }
    }
}
