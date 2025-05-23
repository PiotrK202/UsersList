//
//  UserAddViewModel.swift
//  UsersList
//
//  Created by piotr koscielny on 23/5/25.
//

import Foundation

// MARK: ViewModel for adding user

@Observable
final class UserAddViewModel {
    private let repository: RepositoryProtocol
    var name = ""
    var job = ""
    
    init(repository: RepositoryProtocol) {
        self.repository = repository
    }
    
    func creatUser() async throws {
        let request = CreateUserRequest(name: name, job: job)
        do {
           _ = try await repository.addUser(request)
        } catch {
            throw error
        }
    }
}
