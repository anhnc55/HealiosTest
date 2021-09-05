//
//  PostsViewModelTests.swift
//  HealiosTests
//
//  Created by Anh Nguyen on 24/08/2021.
//

@testable import Healios
import XCTest
import RxSwift
import RxCocoa
import RxBlocking

final class PostsViewModelTests: XCTestCase {
    private var viewModel: PostsViewModel!
    private var navigator: PostsNavigatorMock!
    private var useCase: PostsUseCaseMock!
    
    private var input: PostsViewModel.Input!
    private var output: PostsViewModel.Output!
    
    let disposeBag = DisposeBag()

    private let loadTrigger = PublishSubject<Void>()
    private let selectPostTrigger = PublishSubject<IndexPath>()
    
    override func setUp() {
        super.setUp()
        navigator = PostsNavigatorMock()
        useCase = PostsUseCaseMock()

        viewModel = PostsViewModel(navigator: navigator, useCase: useCase)
        
        input = PostsViewModel.Input(loadTrigger: loadTrigger.asDriver { error in
            return Driver.empty()
        },
                                     selectPostTrigger: selectPostTrigger.asDriver { error in
            return Driver.empty()
        })
        output = viewModel.transform(input)
    }
    
    func test_load_post_list_success() {
        // act
        output.posts.drive().disposed(by: disposeBag)
        loadTrigger.onNext(())
        let posts = try! output.posts.toBlocking().first()

        // assert
        XCTAssert(useCase.getPostsCalled)
        XCTAssertTrue(posts?.count == 1)
    }
    
    func test_selectPostTrigger_toPostDetail() {
        output.posts.drive().disposed(by: disposeBag)
        output.selectedPost.drive().disposed(by: disposeBag)
        loadTrigger.onNext(())
        selectPostTrigger.onNext(IndexPath(row: 0, section: 0))

        // assert
        XCTAssertTrue(navigator.toPostDetailCalled)
    }
}
