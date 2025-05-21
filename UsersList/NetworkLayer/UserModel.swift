//
//  UserModel.swift
//  UsersList
//
//  Created by piotr koscielny on 20/5/25.
//

import Foundation

// MARK: Models

struct User: Decodable, Equatable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id, email, avatar
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

struct Support: Decodable, Equatable {
    let url: String
    let text: String
}

struct UsersResponse: Decodable, Equatable {
    let page: Int
    let perPage: Int
    let total: Int
    let totalPages: Int
    let data: [User]
    let support: Support

    enum CodingKeys: String, CodingKey {
        case page, total, data, support
        case perPage = "per_page"
        case totalPages = "total_pages"
    }
}

struct CreateUserRequest: Encodable, Equatable {
    let firstName: String
    let lastName: String
    let email: String

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email
    }
}

struct CreateUserResponse: Decodable, Equatable {
    let name: String
    let job: String?
    let id: String
    let createdAt: String
}

struct UpdateUserRequest: Encodable, Equatable {
    let name: String
    let job: String
}

struct UpdateUserResponse: Decodable, Equatable {
    let name: String
    let job: String
    let updatedAt: String
}

struct EmptyResponse: Decodable, Equatable {}
