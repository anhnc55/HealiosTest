//
//  PostsUseCaseMock.swift
//  HealiosTests
//
//  Created by Anh Nguyen on 24/08/2021.
//

@testable import Healios
import RxSwift

final class PostsUseCaseMock: PostsUseCaseType {
    var getPostsCalled = false
    var getPostsReturnValue = Observable.just([Post.mock])
    func getPosts() -> Observable<[Post]> {
        getPostsCalled = true
        return getPostsReturnValue
    }
    
    var savePostsToDBCalled = false
    var savePostsToDBReturnValue = Observable.just(true)
    func savePostsToDB(_ posts: [Post]) -> Observable<Bool> {
        savePostsToDBCalled = true
        return savePostsToDBReturnValue
    }
    
    var retrievePostFromDBCalled = false
    var retrievePostFromDBReturnValue = Observable.just([Post.mock, Post.mock])
    
    func retrievePostFromDB() -> Observable<[Post]> {
        retrievePostFromDBCalled = true
        return retrievePostFromDBReturnValue
    }
}
