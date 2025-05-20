//
//  NetworkLayer.swift
//  UsersList
//
//  Created by piotr koscielny on 20/5/25.
//

import Foundation

enum Endpoint {
    case getUsers(page: Int)
    case createUser
    case updateUser(id: Int)
    case deleteUser(id: Int)

    var path: String {
        switch self {
        case .getUsers(let page):
            return "users?page=\(page)"
        case .createUser:
            return "users"
        case .updateUser(let id):
            return "users/\(id)"
        case .deleteUser(let id):
            return "users/\(id)"
        }
    }

    var method: HttpMethod {
        switch self {
        case .getUsers:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .patch
        case .deleteUser:
            return .delete
        }
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}
