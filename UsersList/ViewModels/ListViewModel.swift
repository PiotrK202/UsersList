//
//  ListViewModel.swift
//  UsersList
//
//  Created by piotr koscielny on 22/5/25.
//

import Foundation

@Observable
final class ListViewModel {
    private let repository: RepositoryProtocol
    private(set) var users = [User]()
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchUsers() async throws {
        do {
            var page = 1
            var allUsers: [User] = []
            var totalPages: Int = 1
            
            repeat {
                let response = try await repository.fetchUsers(page: page)
                allUsers.append(contentsOf: response.data)
                totalPages = response.totalPages
                page += 1
            } while page <= totalPages
                        self.users = allUsers
        } catch {
            throw error
        }
    }
    
    func deleteUser(at indexSet: IndexSet) async throws {
        for index in indexSet {
            let user = users[index]
            
            do {
                try await repository.deleteUser(id: user.id)
                users.remove(at: index)
            } catch {
                throw error
            }
        }
    }
}
