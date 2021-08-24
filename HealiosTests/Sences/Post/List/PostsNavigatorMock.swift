//
//  PostsNavigatorMock.swift
//  HealiosTests
//
//  Created by Anh Nguyen on 24/08/2021.
//

@testable import Healios

final class PostsNavigatorMock: PostsNavigatorType {
    var toPostDetailCalled = false
    func toPostDetail(post: Post) {
        toPostDetailCalled = true
    }
}
