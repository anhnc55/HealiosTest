//
//  Comments.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import Combine

extension Comment {
    static func getComments() -> AnyPublisher<[Comment], APIError> {
        return API.shared
            .request(endpoint: .comments)
            .eraseToAnyPublisher()
    }
}
