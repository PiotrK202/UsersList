//
//  RepositoryTests.swift
//  UsersListUnitTests
//
//  Created by piotr koscielny on 21/5/25.
//

import Foundation
import Testing
@testable import UsersList

struct RepositoryTests {
    
    var repository = RepositoryMock()

    @Test func testFetchUsersSuccess() async throws {
        
        let users = try await repository.fetchUsers(page: 1)
        #expect(users.count == 1)
        #expect(users[0].firstName == "John")
    }

    @Test mutating func testFetchUsersFailure() async throws {
        
        repository.error = true
        
        do {
            _ = try await repository.fetchUsers(page: 1)
        } catch {
            #expect(error is MockError)
        }
    }

    @Test func testAddUserSuccess() async throws {
        let request = CreateUserRequest(firstName: "John", lastName: "Doe", email: "john@example.com")
        let response = try await repository.addUser(request)
        #expect(response.name == "John Doe")
        #expect(response.id == "123")
    }

    @Test mutating func testAddUserFailure() async throws {
        
        repository.error = true
        
        let request = CreateUserRequest(firstName: "John", lastName: "Doe", email: "john@example.com")
        do {
            _ = try await repository.addUser(request)
        } catch {
            #expect(error is MockError)
        }
    }

    @Test func testUpdateUserSuccess() async throws {
        let request = UpdateUserRequest(name: "Jane", job: "Engineer")
        let response = try await repository.updateUser(id: 1, with: request)
        #expect(response.name == "Jane")
        #expect(response.job == "Engineer")
    }

    @Test mutating func testUpdateUserFailure() async throws {
        
        repository.error = true
        
        let request = UpdateUserRequest(name: "Jane", job: "Engineer")
        do {
            _ = try await repository.updateUser(id: 1, with: request)
        } catch {
            #expect(error is MockError)
        }
    }

    @Test func testDeleteUserSuccess() async throws {
        try await repository.deleteUser(id: 1)
        #expect(true)
    }

    @Test mutating func testDeleteUserFailure() async throws {
        
        repository.error = true
        
        do {
            try await repository.deleteUser(id: 1)
        } catch {
            #expect(error is MockError)
        }
    }
}
