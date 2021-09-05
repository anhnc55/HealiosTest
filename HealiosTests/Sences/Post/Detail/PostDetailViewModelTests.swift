//
//  PostDetailViewModelTests.swift
//  HealiosTests
//
//  Created by Anh Nguyen on 24/08/2021.
//

@testable import Healios
import XCTest
import RxCocoa
import RxSwift

final class PostDetailViewModelTests: XCTestCase {
    private var viewModel: PostDetailViewModel!
    private var navigator: PostDetailNavigatorMock!
    private var useCase: PostDetailUseCaseMock!
    
    private var input: PostDetailViewModel.Input!
    private var output: PostDetailViewModel.Output!
    
    private var disposeBag = DisposeBag ()
    
    private let loadTrigger = PublishSubject<Void>()
    
    override func setUp() {
        super.setUp()
        navigator = PostDetailNavigatorMock()
        useCase = PostDetailUseCaseMock()
        
        viewModel = PostDetailViewModel(navigator: navigator, useCase: useCase, post: Post.mock)
        
        input = PostDetailViewModel.Input(loadTrigger: loadTrigger.asDriver { error in
            return Driver.empty()
        })
        output = viewModel.transform(input)
    }
    
    func test_load_users_success() {
        // act
        output.user.drive().disposed(by: disposeBag)
        loadTrigger.onNext(())
        // assert
        XCTAssert(useCase.getUsersCalled)
    }
    
    func test_load_comments_success() {
        // act
        output.comments.drive().disposed(by: disposeBag)
        loadTrigger.onNext(())
        let comments = try! output.comments.toBlocking().first()

        // assert
        XCTAssert(useCase.getCommentsCalled)
        XCTAssertTrue(comments?.count == 0)
    }

}
