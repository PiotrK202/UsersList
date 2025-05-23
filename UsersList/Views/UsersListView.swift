//
//  ContentView.swift
//  UsersList
//
//  Created by piotr koscielny on 19/5/25.
//

import SwiftUI

struct UsersListView: View {
    @Bindable private var viewModel: UsersListViewModel
    @State private var isShowingSheet = false
    @State private var isShowingAlert = false
  
    init(viewModel: UsersListViewModel) {
        self.viewModel = viewModel
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
                .onDelete(perform: deleteUser)
            }
            .refreshable {
                fetchUsers()
            }
            .onAppear {
                fetchUsers()
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
                UserAddView(viewModel: UserAddViewModel(repository: Repository(dataService: DataService(session: URLSessionHelper.session))))
            }

            .alert(isPresented: $isShowingAlert) {
                Alert(title: Text("error"), message: Text("somoething went wrong"), dismissButton: .cancel())
            }
        }
    }
    
    private func fetchUsers() {
        Task {
            do {
                try await viewModel.fetchUsers()
            } catch {
                print(error.localizedDescription)
                isShowingAlert = true
            }
        }
    }
    
    private func deleteUser(indexSet: IndexSet) {
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

#Preview {
    let viewModelPreview = UsersListViewModel(repository: Repository(dataService: DataService(session: URLSessionHelper.session)))
    UsersListView(viewModel: viewModelPreview)
}
