//
//  UserAddView.swift
//  UsersList
//
//  Created by piotr koscielny on 22/5/25.
//

import SwiftUI

struct UserAddView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable private var viewModel: UserAddViewModel
    @State private var showAlert = false

    init(viewModel: UserAddViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("User Name") {
                    TextField("name", text: $viewModel.name)
                        .accessibilityIdentifier(AccessibilityIdentifiers.UserAddView.userNameTextField)
                }
                Section("User Job") {
                    TextField("Job", text: $viewModel.job)
                        .accessibilityIdentifier(AccessibilityIdentifiers.UserAddView.userJobTextField)
                }
                
                Button("Add") {
                    Task {
                        do {
                            try await viewModel.creatUser()
                            dismiss()
                        } catch {
                            showAlert = true
                        }
                    }
                }
                .accessibilityIdentifier(AccessibilityIdentifiers.UserAddView.addUserButton)
            }
            
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button("X") {
                        dismiss()
                    }
                    .buttonStyle(.plain)
                }
            })
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Adding user went wrong"), dismissButton: .cancel())
            }
        }
        .accessibilityIdentifier(AccessibilityIdentifiers.UserAddView.addUserView)
    }
}

#Preview {
    UserAddView(viewModel: UserAddViewModel(repository: Repository(dataService: DataService(session: URLSessionHelper.session))))
}
