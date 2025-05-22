//
//  ListViewModel.swift
//  UsersList
//
//  Created by piotr koscielny on 22/5/25.
//

import Foundation

@Observable
final class UsersListViewModel {
    private let repository: RepositoryProtocol
    private var currentPage = 1
    private var totalPages = 1
    var users = [User]()
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchUsers() async throws {
        guard currentPage <= totalPages else { return }
        
        repeat {
            do {
                let response = try await repository.fetchUsers(page: currentPage)
                users.append(contentsOf: response.data)
                totalPages = response.totalPages
                currentPage += 1
            } catch {
                throw error
            }
        } while currentPage <= totalPages
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
