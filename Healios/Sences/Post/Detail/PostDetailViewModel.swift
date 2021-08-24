//
//  PostDetailViewModel.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import Combine
import Foundation

struct PostDetailViewModel {
    let navigator: PostDetailNavigatorType
    let useCase: PostDetailUseCaseType
    let post: Post
}

// MARK: - ViewModelType
extension PostDetailViewModel: ViewModelType {
    struct Input {
        let loadTrigger: AnyPublisher<Void, Never>
    }
    
    final class Output: ObservableObject {
        @Published var post: Post?
        @Published var user: User?
        @Published var comments = [Comment]()
    }
    
    func transform(_ input: Input,_ cancelBag: CancelBag) -> Output {
        let output = Output()

        input.loadTrigger
            .sink (receiveValue: { _ in
                output.post = self.post
            })
            .store(in: cancelBag)
        
        input.loadTrigger
            .flatMap {
                self.useCase
                    .getUsers()
                    .catch { _ in Empty() }
            }
            .sink(receiveValue: { users in
                output.user = users.filter({ $0.id == self.post.userId }).first
            })
            .store(in: cancelBag)
        
        input.loadTrigger
            .flatMap {
                self.useCase
                    .getComments()
                    .catch { _ in Empty() }
            }
            .sink(receiveValue: { comments in
                output.comments = comments.filter({ $0.postId == self.post.id })
            })
            .store(in: cancelBag)

        return output
    }
}
