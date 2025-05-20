//
//  DataService.swift
//  UsersList
//
//  Created by piotr koscielny on 20/5/25.
//

import Foundation

protocol DataServiceProtocol {
    func fetchData<T: Codable>(endpoint: Endpoint) async throws -> T where T: Codable
    func postData<T: Codable>(endpoint: Endpoint, body: T) async throws
}

final class DataService: DataServiceProtocol {
    
    private let baseURL = URL(string: "https://reqres.in/api")!
    private let apiKey = "reqres-free-v1"
    private let apiHeaderKey = "x-api-key"
    private let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    func fetchData<T: Codable>(endpoint: Endpoint) async throws -> T where T: Codable {
        
        let decoder = JSONDecoder()
        
        session.configuration.timeoutIntervalForRequest = 10
        
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get
        request.setValue(apiKey, forHTTPHeaderField: apiHeaderKey)
        
        do {
            let (data, response) = try await session.data(for: request)
            try httpResponse(response: response)
            return try decoder.decode(T.self, from: data)
        } catch {
            throw error
        }
    }
    
    func postData<T: Codable>(endpoint: Endpoint, body: T) async throws {
        
        let encoder =  JSONEncoder()
        
        session.configuration.timeoutIntervalForRequest = 10
        
        guard let url = URL(string: endpoint.path, relativeTo: baseURL) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post
        request.setValue(apiKey, forHTTPHeaderField: apiHeaderKey)
        
        do {
            request.httpBody = try encoder.encode(body)
            let (_, response) = try await session.data(for: request)
            try httpResponse(response: response)
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

