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
        return try await dataService.handelData(endpoint: .getUsers(page: page), responseType: UsersResponse.self)
    }
    
    func addUser(_ body: CreateUserRequest) async throws -> CreateUserResponse  {
        return try await dataService.handelData(endpoint: .createUser(body: body), responseType: CreateUserResponse.self)
    }
    
    func updateUser(id: Int, with body: UpdateUserRequest) async throws -> UpdateUserResponse {
        return try await dataService.handelData(endpoint: .updateUser(id: id, body: body), responseType: UpdateUserResponse.self)
    }
    
    func deleteUser(id: Int) async throws {
        try await dataService.handelData(endpoint: .deleteUser(id: id), responseType: EmptyResponse.self)
    }
}
