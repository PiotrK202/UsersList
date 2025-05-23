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
                }
                Section("User Job") {
                    TextField("Job", text: $viewModel.job)
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
    }
}

#Preview {
    UserAddView(viewModel: UserAddViewModel(repository: Repository(dataService: DataService(session: URLSessionHelper.session))))
}
