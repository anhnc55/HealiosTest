//
//  Comments.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import RxSwift

extension Comment {
    static func getComments() -> Observable<[Comment]> {
        Network<Comment>().getItems(.comments)
    }
}
