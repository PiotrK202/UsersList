//
//  RepositoryMock.swift
//  UsersListUnitTests
//
//  Created by piotr koscielny on 21/5/25.
//

import Foundation
@testable import UsersList

struct RepositoryMock: RepositoryProtocol {

    var error = false
    
    func fetchUsers(page: Int) async throws -> UsersResponse {
        guard !error else {
            throw MockError.error
        }
        let user = [User(id: 1, email: "email", firstName: "name", lastName: "lastName", avatar: "avatar")]
        return UsersResponse(page: 1, perPage: 1, total: 1, totalPages: 1, data: user)
    }

    func addUser(_ body: CreateUserRequest) async throws -> CreateUserResponse {
        guard !error else {
            throw MockError.error
        }
        return CreateUserResponse(name: body.name, job: body.job, id: "id", createdAt: "2025-05-21T10:00:00.000Z")
    }

    func updateUser(id: Int, with body: UpdateUserRequest) async throws -> UpdateUserResponse {
        guard !error else {
            throw MockError.error
        }
        return UpdateUserResponse(name: body.name, job: body.job, updatedAt: "2025-05-21T10:00:00.000Z")
    }

    func deleteUser(id: Int) async throws {
        guard !error else {
            throw MockError.error
        }
    }
}

enum MockError: Error {
    case error
}

