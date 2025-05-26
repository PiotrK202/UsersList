//
//  UserDetailViewModel.swift
//  UsersList
//
//  Created by piotr koscielny on 23/5/25.
//

import Foundation
import SwiftUI

@Observable
final class UserDetailViewModel {
    private let repository: RepositoryProtocol
    private(set) var name: String
    private(set) var job: String
    private(set) var user: User
    
    init(repository: RepositoryProtocol, user: User) {
        self.repository = repository
        self.user = user
        self.name = "\(user.firstName) \(user.lastName)"
        self.job = "unknown"
    }
    
    func updateUser(newName:String, newJob: String) async throws {
        let request = UpdateUserRequest(name: newName, job: newJob)
        
        do {
            _ = try await repository.updateUser(id: user.id, with: request)
            self.name = newName
            self.job = newJob
        } catch {
            throw error
        }
      
    }
}
