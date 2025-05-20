//
//  Repository.swift
//  UsersList
//
//  Created by piotr koscielny on 20/5/25.
//

import Foundation

protocol RepositoryProtocol {
    func fetchUsers(page: Int) async throws -> [User]
    func addUser(_ request: CreateUserRequest) async throws
    func updateUser(id: Int, with request: UpdateUserRequest) async throws
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
    
    func addUser(_ request: CreateUserRequest) async throws {
        _ = try await dataService.handelData(endpoint: .createUser(body: request), responseType: EmptyResponse.self)
    }
    
    func updateUser(id: Int, with request: UpdateUserRequest) async throws {
        _ = try await dataService.handelData(endpoint: .updateUser(id: id, body: request), responseType: EmptyResponse.self)
    }
    
    func deleteUser(id: Int) async throws {
        _ = try await dataService.handelData(endpoint: .deleteUser(id: id), responseType: EmptyResponse.self)
    }
}
