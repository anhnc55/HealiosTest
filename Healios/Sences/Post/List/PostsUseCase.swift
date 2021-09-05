//
//  PostsUseCase.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//
import RxSwift

protocol PostsUseCaseType {
    func getPosts() -> Observable<[Post]>
}

struct PostsUseCase: PostsUseCaseType {
    func getPosts() -> Observable<[Post]> {
        let localPosts = Post.retrievePostFromDB()
        let savePostsToLocal = Post.getPosts()
            .flatMap { posts in
                return Post.savePostsToDB(posts)
                    .map { _ in
                        return posts
                    }
            }
        return Observable.concat([localPosts.take(1), savePostsToLocal])
    }
}
