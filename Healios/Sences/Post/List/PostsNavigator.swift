//
//  PostsNavigator.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import UIKit

protocol PostsNavigatorType {
    func toPostDetail(post: Post)
}

struct PostsNavigator: PostsNavigatorType {
    let navigationController: UINavigationController
    
    func toPostDetail(post: Post) {
        let postDetailVC = AppRoute.createPostDetailViewController(navi: navigationController,
                                                                   post: post)
        navigationController.pushViewController(postDetailVC, animated: true)
    }
}
