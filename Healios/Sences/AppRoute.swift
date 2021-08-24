//
//  AppRoute.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import UIKit
import SwiftUI

class AppRoute {
    static func createPostsViewController(navi: UINavigationController) -> UIViewController {
        let storyboard = Storyboards.main
        let viewController = storyboard.instantiateViewController(ofType: PostsViewController.self)
        let navigator = PostsNavigator(navigationController: navi)
        let useCase = PostsUseCase()
        let viewModel = PostsViewModel(navigator: navigator, useCase: useCase)
        viewController.viewModel = viewModel
        
        return viewController
    }
    
    static func createPostDetailViewController(navi: UINavigationController, post: Post) -> UIViewController {
        let storyboard = Storyboards.main
        let viewController = storyboard.instantiateViewController(ofType: PostDetailViewController.self)
        let navigator = PostDetailNavigator(navigationController: navi)
        let useCase = PostDetailUseCase()
        let viewModel = PostDetailViewModel(navigator: navigator,
                                            useCase: useCase,
                                            post: post)
        viewController.viewModel = viewModel
        
        return viewController
    }
}
