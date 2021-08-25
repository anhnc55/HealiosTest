//
//  PostsViewModel.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import Foundation
import Combine

struct PostsViewModel {
    let navigator: PostsNavigatorType
    let useCase: PostsUseCaseType
}

// MARK: - ViewModelType
extension PostsViewModel: ViewModelType {
    struct Input {
        let loadTrigger: AnyPublisher<Void, Never>
        let searchTextTrigger: AnyPublisher<String, Never>
        let selectPostTrigger: AnyPublisher<IndexPath, Never>
    }
    
    final class Output: ObservableObject {
        @Published var posts = [Post]()
    }
    
    func transform(_ input: Input, _ cancelBag: CancelBag) -> Output {
        let output = Output()
        
        let postsFromDB = input.loadTrigger
            .flatMap({
                self.useCase.retrievePostFromDB()
                    .catch { _ in Empty() }
            })
        
        let postsFromAPI = input.loadTrigger
            .flatMap { posts in
                self.useCase
                    .getPosts()
                    .catch { _ in Empty() }
            }
            .flatMap { posts in
                return self.useCase
                    .savePostsToDB(posts)
                    .catch { _ in Empty() }
            }
            .flatMap({ _ in
                self.useCase.retrievePostFromDB()
                    .catch { _ in Empty() }
            })
        
        Publishers.Concatenate(prefix: postsFromDB,
                               suffix: postsFromAPI)
            .assign(to: \.posts, on: output)
            .store(in: cancelBag)

        input.selectPostTrigger
            .sink(receiveValue: {
                let post = output.posts[$0.row]
                self.navigator.toPostDetail(post: post)
            })
            .store(in: cancelBag)
        
        return output
    }
}
