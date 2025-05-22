//
//  ContentView.swift
//  UsersList
//
//  Created by piotr koscielny on 19/5/25.
//

import SwiftUI

struct UsersListView: View {
    @State private var viewModel: UsersListViewModel
    @State private var isShowingSheet = false
    @State private var isShowingAlert = false
    
    init(viewModel: UsersListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.users) { user in
                    NavigationLink {
                        UserDetailView()
                    } label: {
                        HStack {
                            AsyncImage(url: URL(string: user.avatar)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else if phase.error != nil {
                                    Color.red
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    ProgressView()
                                        .frame(width: 40, height: 40)
                                }
                            }
                            Text("\(user.firstName) \(user.lastName)")
                                .font(.body)
                        }
                    }
                }
                .onDelete { indexSet in
                    Task {
                        do {
                            try await viewModel.deleteUser(at: indexSet)
                        } catch {
                            print(error.localizedDescription)
                            isShowingAlert = true
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add") {
                        isShowingSheet.toggle()
                    }
                }
            }
            .sheet(isPresented: $isShowingSheet) {
                UserAddView()
            }
            .task {
                do {
                    try await viewModel.fetchUsers()
                } catch {
                    print(error.localizedDescription)
                    isShowingAlert = true
                }
            }
            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("error"), message: Text("somoething went wrong"), dismissButton: .cancel())
            }
        }
    }
}

#Preview {
    let viewModelPreview = UsersListViewModel(repository: Repository(dataService: DataService(session: URLSessionHelper.session)))
    UsersListView(viewModel: viewModelPreview)
}
