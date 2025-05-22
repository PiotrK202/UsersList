//
//  UsersListApp.swift
//  UsersList
//
//  Created by piotr koscielny on 19/5/25.
//

import SwiftUI

@main
struct UsersListApp: App {
    var body: some Scene {
        WindowGroup {
            ListView(viewModel: ListViewModel(repository: Repository(dataService: DataService(session: URLSessionHelper.session))))
        }
    }
}
