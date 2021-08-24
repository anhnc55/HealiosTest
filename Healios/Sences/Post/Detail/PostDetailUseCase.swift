//
//  PostDetailUseCase.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import Combine

protocol PostDetailUseCaseType {
    func getUsers() -> AnyPublisher<[User], APIError>
    func getComments() -> AnyPublisher<[Comment], APIError>
}

struct PostDetailUseCase: PostDetailUseCaseType {
    func getUsers() -> AnyPublisher<[User], APIError> {
        User
            .getUsers()
            .eraseToAnyPublisher()
    }
    
    func getComments() -> AnyPublisher<[Comment], APIError> {
        Comment
            .getComments()
            .catch { _ in Empty() }
            .eraseToAnyPublisher()
    }

}
