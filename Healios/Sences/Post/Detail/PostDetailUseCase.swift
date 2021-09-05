//
//  PostDetailUseCase.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import RxSwift
import RxCocoa

protocol PostDetailUseCaseType {
    func getUsers() -> Observable<[User]>
    func getComments() -> Observable<[Comment]>
}

struct PostDetailUseCase: PostDetailUseCaseType {
    func getUsers() -> Observable<[User]> {
        Network().getItems(.users)
    }
    
    func getComments() -> Observable<[Comment]> {
        Network().getItems(.comments)
    }
}
