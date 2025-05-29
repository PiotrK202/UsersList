//
//  UserDetailViewModelTests.swift
//  UsersListUnitTests
//
//  Created by piotr koscielny on 26/5/25.
//

import Testing
@testable import UsersList

struct UserDetailViewModelTests {
    var repository = RepositoryMock()

    @Test func testUpdateUserWithExpectetionToSuccess() async throws {
        let viewModel = UserDetailViewModel(repository: repository, user: repository.testUser)
        #expect(repository.testUser.firstName == "name")
        
        let newName = "new name"
        let newJob = "new job"
        
        try await viewModel.updateUser(newName: newName, newJob: newJob)
        #expect(viewModel.job == newJob)
        #expect(viewModel.name == newName)
    }
    
    @Test mutating func testUpdateUserWithExpectetionToFail() async throws {
        repository.error = true
        let newName = "new name"
        let newJob = "new job"
        let viewModel = UserDetailViewModel(repository: repository, user: repository.testUser)
        await #expect(throws: MockError.self) {
            try await viewModel.updateUser(newName: newName, newJob: newJob)
        }
    }
}
