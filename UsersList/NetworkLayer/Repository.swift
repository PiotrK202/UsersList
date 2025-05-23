//
//  Repository.swift
//  UsersList
//
//  Created by piotr koscielny on 20/5/25.
//

import Foundation

protocol RepositoryProtocol {
    func fetchUsers(page: Int) async throws -> UsersResponse
    func addUser(_ body: CreateUserRequest) async throws -> CreateUserResponse
    func updateUser(id: Int, with body: UpdateUserRequest) async throws -> UpdateUserResponse
    func deleteUser(id: Int) async throws
}

final class Repository: RepositoryProtocol {
    
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func fetchUsers(page: Int) async throws -> UsersResponse {
        return try await dataService.handelData(endpoint: .getUsers(page: page))
    }
    
    func addUser(_ body: CreateUserRequest) async throws -> CreateUserResponse  {
        return try await dataService.handelData(endpoint: .createUser(body: body))
    }
    
    func updateUser(id: Int, with body: UpdateUserRequest) async throws -> UpdateUserResponse {
        return try await dataService.handelData(endpoint: .updateUser(id: id, body: body))
    }
    
    func deleteUser(id: Int) async throws {
        try await dataService.handelData(endpoint: .deleteUser(id: id))
    }
}
