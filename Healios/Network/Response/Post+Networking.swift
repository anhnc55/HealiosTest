//
//  Post+Networking.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import Combine

extension Post {
    static func getPosts() -> AnyPublisher<[Post], APIError> {
        return API.shared
            .request(endpoint: .posts)
            .eraseToAnyPublisher()
    }
}
