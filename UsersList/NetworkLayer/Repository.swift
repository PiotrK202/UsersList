//
//  Repository.swift
//  UsersList
//
//  Created by piotr koscielny on 20/5/25.
//

import Foundation

protocol RepositoryProtocol {
    func fetchUsers(page: Int) async throws -> [User]
    func addUser(_ request: CreateUserRequest) async throws -> CreateUserResponse 
    func updateUser(id: Int, with request: UpdateUserRequest) async throws -> UpdateUserResponse 
    func deleteUser(id: Int) async throws
}

final class Repository: RepositoryProtocol {
    
    private let dataService: DataServiceProtocol
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
    }
    
    func fetchUsers(page: Int) async throws -> [User] {
        let response: UsersResponse = try await dataService.handelData(endpoint: .getUsers(page: page), responseType: UsersResponse.self)
        return response.data
    }
    
    func addUser(_ request: CreateUserRequest) async throws -> CreateUserResponse  {
        try await dataService.handelData(endpoint: .createUser(body: body), responseType: CreateUserResponse.self)
    }
    
    func updateUser(id: Int, with request: UpdateUserRequest) async throws -> UpdateUserResponse {
        try await dataService.handelData(endpoint: .updateUser(id: id, body: body), responseType: UpdateUserResponse.self)
    }
    
    func deleteUser(id: Int) async throws {
        try await dataService.handelData(endpoint: .deleteUser(id: id), responseType: EmptyResponse.self)
    }
}
