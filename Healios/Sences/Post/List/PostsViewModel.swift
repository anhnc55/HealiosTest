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
        let searchTextTrigger: Driver<String>
        let selectPostTrigger: Driver<IndexPath>
    }
    
    struct Output {
        let posts: Driver<[Post]>
    }
    
    func transform(_ input: Input) -> Output {
        let posts = input.loadTrigger.flatMapLatest {
            return self.useCase
                .getPosts()
                .asDriverOnErrorJustComplete()
        }

        let output = Output(posts: posts)
        
//        input.loadTrigger
//            .flatMap({
//                self.useCase.retrievePostFromDB()
//                    .catch { _ in Empty() }
//            })
//            .assign(to: \.posts, on: output)
//            .store(in: cancelBag)
//
//        input.loadTrigger
//            .flatMap { posts in
//                self.useCase
//                    .getPosts()
//                    .catch { _ in Empty() }
//            }
//            .flatMap { posts in
//                return self.useCase
//                    .savePostsToDB(posts)
//                    .catch { _ in Empty() }
//            }
//            .flatMap({ _ in
//                self.useCase.retrievePostFromDB()
//                    .catch { _ in Empty() }
//            })
//            .assign(to: \.posts, on: output)
//            .store(in: cancelBag)
//
//        input.selectPostTrigger
//            .sink(receiveValue: {
//                let post = output.posts[$0.row]
//                self.navigator.toPostDetail(post: post)
//            })
//            .store(in: cancelBag)
//
//        return output
    }
}
