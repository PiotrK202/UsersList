//
//  UsersListViewModelTests.swift
//  UsersListUnitTests
//
//  Created by piotr koscielny on 23/5/25.
//

import Foundation
import Testing
@testable import UsersList

struct UsersListViewModelTests {
    var repository = RepositoryMock()
    
    @Test func testFetchUsersWithExpectetionToSuccess() async throws {
        let viewModel = UsersListViewModel(repository: repository)
        try await viewModel.fetchUsers()
        #expect(viewModel.users.count == 1)
        #expect(viewModel.users.first?.firstName == "name")
    }
    
    @Test mutating func testFetchUsersWithExpectetionToFaill() async throws {
        repository.error = true
        let viewModel = UsersListViewModel(repository: repository)
        await #expect(throws:MockError.self) {
            try await viewModel.fetchUsers()
        }
    }
    
    @Test func testDeleteUsersWithExpectetionToSuccess() async throws {
        let viewModel = UsersListViewModel(repository: repository)
        try await viewModel.fetchUsers()
        #expect(viewModel.users.count == 1)
        try await viewModel.deleteUser(at: IndexSet(integer: 0))
        #expect(viewModel.users.isEmpty)
    }
    
    @Test mutating func testDeleteUsersWithExpectetionToFaill() async throws {
        let viewModel = UsersListViewModel(repository: repository)
        try await viewModel.fetchUsers()
        #expect(viewModel.users.count == 1)
        repository.error = true
        
        do {
            try await viewModel.deleteUser(at: IndexSet(integer: 0))
        } catch {
            #expect(error is MockError)
        }
    }
}
