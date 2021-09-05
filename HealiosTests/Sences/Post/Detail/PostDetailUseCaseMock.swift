//
//  PostDetailUseCaseMock.swift
//  HealiosTests
//
//  Created by Anh Nguyen on 24/08/2021.
//

@testable import Healios
import RxSwift

final class PostDetailUseCaseMock: PostDetailUseCaseType {
    var getUsersCalled = false
    var getUsersReturnValue: Observable<[User]> = Observable.just([])
    func getUsers() -> Observable<[User]> {
        getUsersCalled = true
        return getUsersReturnValue
    }
    
    var getCommentsCalled = false
    var getCommentsReturnValue: Observable<[Comment]> = Observable.just([])
    func getComments() -> Observable<[Comment]> {
        getCommentsCalled = true
        return getCommentsReturnValue
    }
}
