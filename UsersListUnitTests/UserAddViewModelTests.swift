//
//  UserAddViewModelTests.swift
//  UsersListUnitTests
//
//  Created by piotr koscielny on 23/5/25.
//

import Foundation
import Testing
@testable import UsersList

struct UserAddViewModelTests {
    var repository = RepositoryMock()
    
    
    @Test func testCreateUserWithExpectetionToSuccess() async throws {
        let viewModel = UserAddViewModel(repository: repository)
        viewModel.name = "name"
        viewModel.job = "job"
        try await viewModel.creatUser()
        #expect(true)
    }
    
    @Test mutating func testCreateUserWithExpectetionToFail() async throws {
        repository.error = true
        let viewModel = UserAddViewModel(repository: repository)
        viewModel.name = "name"
        viewModel.job = "job"
        await #expect(throws: MockError.self) {
            try await viewModel.creatUser()
        }
    }
}
