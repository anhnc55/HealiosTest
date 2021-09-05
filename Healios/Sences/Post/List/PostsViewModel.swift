//
//  PostsViewModel.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct PostsViewModel {
    let navigator: PostsNavigatorType
    let useCase: PostsUseCaseType
}

// MARK: - ViewModelType
extension PostsViewModel: ViewModelType {
    struct Input {
        let loadTrigger: Driver<Void>
        let selectPostTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let posts: Driver<[Post]>
        let selectedPost: Driver<Post>
    }
    
    func transform(_ input: Input) -> Output {
        let posts = input.loadTrigger
            .flatMapLatest { _ in
                self.useCase.getPosts()
                    .asDriver { error in
                        return Driver.empty()
                    }
            }
        
        let selectedPost = input.selectPostTrigger
            .withLatestFrom(posts) { (indexPath, posts) -> Post in
                return posts[indexPath.row]
            }
            .do(onNext: navigator.toPostDetail(post:))

        return Output(posts: posts,
                      selectedPost: selectedPost)
    }
}
