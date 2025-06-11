//
//  DataService.swift
//  UsersList
//
//  Created by piotr koscielny on 20/5/25.
//

import Foundation

protocol DataServiceProtocol {
    func handelData(endpoint: Endpoint) async throws
    func handelData<T: Decodable>(endpoint: Endpoint) async throws -> T
}

final class DataService: DataServiceProtocol {
    
    private let baseURL = "https://reqres.in/api"
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    init(session: URLSession) {
        self.session = session
    }
    
    func handelData(endpoint: Endpoint) async throws {
        try await apiCall(endpoint: endpoint)
    }
    
    func handelData<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let data = try await apiCall(endpoint: endpoint)
        return try decoder.decode(T.self, from: data)
    }
    
    @discardableResult
    private func apiCall(endpoint: Endpoint) async throws -> Data {
        guard let url = URL(string: "\(baseURL)\(endpoint.path)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.bodyEncoder()
        request.addValue("reqres-free-v1", forHTTPHeaderField: "x-api-key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200..<300).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
        
    }
}

