//
//  NetworkLayer.swift
//  UsersList
//
//  Created by piotr koscielny on 20/5/25.
//

import Foundation

enum Endpoint {
    case downloadUsers
    case creatUser
    
    var path: String {
        switch self {
            case .downloadUsers:
            return "users?page=1"
        case .creatUser:
            return "users"
        }
    }
}

enum HttpMethod {
    typealias RawValue = String
    
    static let get = "GET"
    static let post = "POST"
}
