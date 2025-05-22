//
//  ContentView.swift
//  UsersList
//
//  Created by piotr koscielny on 19/5/25.
//

import SwiftUI

struct UsersListView: View {
    @State private var viewModel: ListViewModel
    @State private var isShowingSheet = false
    
    init(viewModel: ListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            LazyVStack {
                List {
                    ForEach(viewModel.users, id: \.id) { user in
                        
                    }
                }
            }
        }
    }
}

#Preview {
    UsersListView(viewModel: ListViewModel(repository: Repository(dataService: DataService(session: URLSessionHelper.session))))
}
