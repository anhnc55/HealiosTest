//
//  PostDetailViewModelTests.swift
//  HealiosTests
//
//  Created by Anh Nguyen on 24/08/2021.
//

@testable import Healios
import XCTest
import Combine

final class PostDetailViewModelTests: XCTestCase {
    private var viewModel: PostDetailViewModel!
    private var navigator: PostDetailNavigatorMock!
    private var useCase: PostDetailUseCaseMock!
    
    private var input: PostDetailViewModel.Input!
    private var output: PostDetailViewModel.Output!
    
    private var cancelBag: CancelBag!
    
    private let loadTrigger = PassthroughSubject<Void, Never>()
    
    override func setUp() {
        super.setUp()
        navigator = PostDetailNavigatorMock()
        useCase = PostDetailUseCaseMock()
        cancelBag = CancelBag()
        viewModel = PostDetailViewModel(navigator: navigator, useCase: useCase, post: Post.mock)
        
        input = PostDetailViewModel.Input(loadTrigger: loadTrigger.eraseToAnyPublisher())
        output = viewModel.transform(input, cancelBag)
    }
    
    func test_load_users_success() {
        let expectation = XCTestExpectation(description: self.debugDescription)

        loadTrigger.send(())
        
        self.useCase
            .getUsersReturnValue.sink { _ in } receiveValue: { PostDetail in
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssert(self.useCase.getUsersCalled)
    }
    
    func test_load_comments_success() {
        let expectation = XCTestExpectation(description: self.debugDescription)

        loadTrigger.send(())
        
        self.useCase
            .getCommentsReturnValue.sink { _ in } receiveValue: { PostDetail in
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssert(self.useCase.getCommentsCalled)
    }

}
