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
