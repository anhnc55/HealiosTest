//
//  Post+Networking.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import RxSwift

extension Post {
    static func getPosts() -> Observable<[Post]> {
        return Network<Post>().getItems(.posts)
    }
}
