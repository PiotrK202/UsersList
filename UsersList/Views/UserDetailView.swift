//
//  UserDetailView.swift
//  UsersList
//
//  Created by piotr koscielny on 22/5/25.
//

import SwiftUI

struct UserDetailView: View {
    @Bindable private var viewModel: UserDetailViewModel
    @State private var showAlert = false
    @State private var localTextFieldName = ""
    @State private var localTextFieldJob = ""
    
    init(viewModel: UserDetailViewModel) {
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: viewModel.user.avatar)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .clipShape(Circle())
                    } else if phase.error != nil {
                        Color.clear
                    } else {
                        ProgressView()
                    }
                }.frame(width: 150, height: 150)
                
                Text(viewModel.user.email)
                    .font(.subheadline)
                
                Text(viewModel.name)
                    .font(.subheadline)
                
                Text(viewModel.job)
                    .font(.subheadline)
                
                TextField("name", text: $localTextFieldName)
                    .accessibilityIdentifier(AccessibilityIdentifiers.UserDetailView.userNameTextField)
                    .padding()
                    .foregroundStyle(.gray)
                    .textFieldStyle(.roundedBorder)
                
                TextField("job",text: $localTextFieldJob)
                    .accessibilityIdentifier(AccessibilityIdentifiers.UserDetailView.userJobTextField)
                    .padding()
                    .foregroundStyle(.gray)
                    .textFieldStyle(.roundedBorder)
                
                Button("update user") {
                    Task {
                        do {
                            try await viewModel.updateUser(newName: localTextFieldName, newJob: localTextFieldJob)
                        } catch {
                            showAlert = true
                        }
                    }
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.UserDetailView.updateUserButton)
            }
            .navigationTitle("detail")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Something went wrong"), dismissButton: .cancel())
            }
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.UserDetailView.userDetailView)
    }
}
