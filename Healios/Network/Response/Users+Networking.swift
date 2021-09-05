//
//  Users.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import RxSwift

extension User {
    static func getUsers() -> Observable<[User]> {
        Network<User>().getItems(.users)
    }
}
