//
//  NetworkLayer.swift
//  UsersList
//
//  Created by piotr koscielny on 20/5/25.
//

import Foundation

enum Endpoint {
    case getUsers(page: Int)
    case createUser(body: CreateUserRequest)
    case updateUser(id: Int, body: UpdateUserRequest)
    case deleteUser(id: Int)

    var path: String {
        switch self {
        case .getUsers(let page):
            return "/users?page=\(page)"
        case .createUser:
            return "/users"
        case .updateUser(let id,_):
            return "/users/\(id)"
        case .deleteUser(let id):
            return "/users/\(id)"
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
    
    func bodyEncoder() -> Data? {
        switch self {
        case .createUser(let body):
            return try? JSONEncoder().encode(body)
        case.updateUser(_, let body):
            return try? JSONEncoder().encode(body)
        default:
            return nil
        }
    }
}

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}
