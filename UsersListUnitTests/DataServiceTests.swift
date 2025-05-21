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
        let expected = CreateUserRequest(firstName: "name", lastName: "lastName", email: "email")
        let jsonData = try JSONEncoder().encode(expected)
        let session = makeSession(data: jsonData, statusCode: 200)
        let dataService = DataService(session: session)
        
        let endpoint = Endpoint.createUser(body: expected)
        
        let result: CreateUserRequest = try await dataService.handelData(endpoint: endpoint, responseType: CreateUserRequest.self)
        #expect(result == expected)
    }

    @Test
    func testFetchDataFailure() async throws {
        let expected = CreateUserRequest(firstName: "name", lastName: "lastName", email: "email")
        let jsonData = try JSONEncoder().encode(expected)
        let session = makeSession(data: jsonData, statusCode: 400)
        let dataService = DataService(session: session)
        let endpoint = Endpoint.createUser(body: expected)
        
        do {
            let _: CreateUserRequest = try await dataService.handelData(endpoint: endpoint, responseType: CreateUserRequest.self)
        } catch let error as URLError {
            #expect(error.code == .badServerResponse)
        }
    }
}
