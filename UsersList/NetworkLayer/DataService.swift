//
//  DataService.swift
//  UsersList
//
//  Created by piotr koscielny on 20/5/25.
//

import Foundation

protocol DataServiceProtocol {
    func handelData<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async throws -> T
}

final class DataService: DataServiceProtocol {
    
    private let baseURL = URL(string: "https://reqres.in/api")!
    private let apiKey = "reqres-free-v1"
    private let apiHeaderKey = "x-api-key"
    private let session: URLSession
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init(session: URLSession) {
        self.session = session
    }
    
    func handelData<T: Decodable>(endpoint: Endpoint, responseType: T.Type) async throws -> T {

        session.configuration.timeoutIntervalForRequest = 10
        
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.setValue(apiKey, forHTTPHeaderField: apiHeaderKey)
        request.httpBody = endpoint.bodyEncoder()
        
        do {
            let (data, response) = try await session.data(for: request)
            try httpResponse(response: response)
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    private func httpResponse(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}

