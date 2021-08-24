//
//  Users.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import Combine

extension User {
    static func getUsers() -> AnyPublisher<[User], APIError> {
        return API.shared
            .request(endpoint: .users)
            .eraseToAnyPublisher()
    }
}
