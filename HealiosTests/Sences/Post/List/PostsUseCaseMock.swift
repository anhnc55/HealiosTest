//
//  PostsUseCaseMock.swift
//  HealiosTests
//
//  Created by Anh Nguyen on 24/08/2021.
//

@testable import Healios
import Combine

final class PostsUseCaseMock: PostsUseCaseType {
    var getPostsCalled = false
    var getPostsReturnValue = Future<[Post], APIError> { promise in
        promise(.success([Post.mock, Post.mock]))
    }
    .eraseToAnyPublisher()
    func getPosts() -> AnyPublisher<[Post], APIError> {
        getPostsCalled = true
        return getPostsReturnValue
    }
    
    var savePostsToDBCalled = false
    var savePostsToDBReturnValue = Future<Bool, Error> { promise in
        promise(.success(true))
    }
    .eraseToAnyPublisher()
    func savePostsToDB(_ posts: [Post]) -> AnyPublisher<Bool, Error> {
        savePostsToDBCalled = true
        return savePostsToDBReturnValue
    }
    
    var retrievePostFromDBCalled = false
    var retrievePostFromDBReturnValue = Future<[Post], Error> { promise in
        promise(.success([Post.mock, Post.mock]))
    }
    .eraseToAnyPublisher()
    func retrievePostFromDB() -> AnyPublisher<[Post], Error> {
        retrievePostFromDBCalled = true
        return retrievePostFromDBReturnValue
    }
}
