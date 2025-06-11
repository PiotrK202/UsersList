//
//  DataServiceTests.swift
//  UsersListUnitTests
//
//  Created by piotr koscielny on 21/5/25.
//

import Foundation
import Testing
@testable import UsersList

struct DataServiceTests {

    private func makeSession(data: Data, statusCode: Int) -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLSessionMock.self]
        URLSessionMock.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
        return URLSession(configuration: config)
    }

    @Test func testFetchDataWithExpectetionToSuccess() async throws {
        let expected = CreateUserRequest(name: "jon", job: "job")
        let jsonData = try JSONEncoder().encode(expected)
        let session = makeSession(data: jsonData, statusCode: 200)
        let dataService = DataService(session: session)
        let endpoint = Endpoint.createUser(body: expected)
        let result: CreateUserRequest = try await dataService.handelData(endpoint: endpoint)
        #expect(result == expected)
    }

    @Test
    func testFetchDataFailure() async throws {
        let expected = CreateUserRequest(name: "jon", job: "job")
        let jsonData = try JSONEncoder().encode(expected)
        let session = makeSession(data: jsonData, statusCode: 400)
        let dataService = DataService(session: session)
        let endpoint = Endpoint.createUser(body: expected)
        
        do {
            try await dataService.handelData(endpoint: endpoint)
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        }
    }
    
    @Test func testFetchDataWithourReturnTypeSucces() async throws {
        let user = User(id: 1, email: "q", firstName: "q", lastName: "q", avatar: "q")
        let jsonData = try JSONEncoder().encode(user)
        let session = makeSession(data: jsonData, statusCode: 204)
        let dataService = DataService(session: session)
        let endpoint = Endpoint.deleteUser(id: 1)
        try await dataService.handelData(endpoint: endpoint)
        #expect(true)
    }
    
    @Test func testFetchDataWithourReturnTypeFailure() async throws {
        let user = User(id: 1, email: "q", firstName: "q", lastName: "q", avatar: "q")
        let jsonData = try JSONEncoder().encode(user)
        let session = makeSession(data: jsonData, statusCode: 400)
        let dataService = DataService(session: session)
        let endpoint = Endpoint.deleteUser(id: 1)
        
        do {
            try await dataService.handelData(endpoint: endpoint)
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        }
    }
}
