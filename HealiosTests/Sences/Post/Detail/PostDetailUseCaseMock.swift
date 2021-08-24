//
//  PostDetailUseCaseMock.swift
//  HealiosTests
//
//  Created by Anh Nguyen on 24/08/2021.
//

@testable import Healios
import Combine

final class PostDetailUseCaseMock: PostDetailUseCaseType {
    var getUsersCalled = false
    var getUsersReturnValue = Future<[User], APIError> { promise in
        promise(.success([]))
    }
    .eraseToAnyPublisher()
    func getUsers() -> AnyPublisher<[User], APIError> {
        getUsersCalled = true
        return getUsersReturnValue
    }
    
    var getCommentsCalled = false
    var getCommentsReturnValue = Future<[Comment], APIError> { promise in
        promise(.success([]))
    }
    .eraseToAnyPublisher()
    func getComments() -> AnyPublisher<[Comment], APIError> {
        getCommentsCalled = true
        return getCommentsReturnValue
    }
}
