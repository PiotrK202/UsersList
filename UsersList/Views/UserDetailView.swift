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
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else if phase.error != nil {
                        Color.clear
                            .frame(width: 100, height: 100)
                    } else {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }
                }
                Text(viewModel.user.email)
                    .font(.subheadline)
                
                Text(viewModel.name)
                    .font(.subheadline)
                
                Text(viewModel.job)
                    .font(.subheadline)
                
                TextField("name", text: $localTextFieldName)
                    .accessibilityIdentifier("nameTextField")
                    .padding()
                    .foregroundStyle(.gray)
                    .textFieldStyle(.roundedBorder)
                
                TextField("job",text: $localTextFieldJob)
                    .accessibilityIdentifier("jobTextField")
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
                .accessibilityIdentifier("updateUserButton")
            }
            .navigationTitle("detail")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Something went wrong"), dismissButton: .cancel())
            }
        }
        .accessibilityIdentifier("userDetailView")
    }
}
