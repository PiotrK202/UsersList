//
//  UserModel.swift
//  UsersList
//
//  Created by piotr koscielny on 20/5/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let email: String
    let firstNname: String
    let lastNname: String
    let avatar: String
}

struct UsersResponse: Codable {
    let data: [User]
}

struct CreateUserRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
}

struct UpdateUserRequest: Codable {
    let name: String
    let job: String
}

struct EmptyResponse: Codable { }
