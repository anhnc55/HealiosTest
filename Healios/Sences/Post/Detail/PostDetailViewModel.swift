//
//  PostDetailViewModel.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct PostDetailViewModel {
    let navigator: PostDetailNavigatorType
    let useCase: PostDetailUseCaseType
    let post: Post
}

// MARK: - ViewModelType
extension PostDetailViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
    }
    
    struct Output {
        let posts: Driver<Post>
        let user: Driver<User>
        let comments: Driver<[Comment]>
    }
    
    func transform(_ input: Input) -> Output {
        let post = input.loadTrigger
            .flatMapLatest {
                Driver.just(self.post)
            }
        
        let user = input.loadTrigger
            .flatMap {
                self.useCase
                    .getUsers()
                    .compactMap {
                        $0.first { $0.id == self.post.userId }
                    }
                    .asDriver { error in
                        return Driver.empty()
                    }
            }
        
        let comments = input.loadTrigger
            .flatMapLatest {
                self.useCase
                    .getComments()
                    .map {
                        $0.filter { $0.postId == self.post.userId }
                    }
                    .asDriver(onErrorDriveWith: Driver.empty())
            }
        
        return Output(posts: post,
                      user: user,
                      comments: comments)
    }
}
