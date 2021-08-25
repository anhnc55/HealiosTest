//
//  PostsViewModelTests.swift
//  HealiosTests
//
//  Created by Anh Nguyen on 24/08/2021.
//

@testable import Healios
import XCTest
import Combine

final class PostsViewModelTests: XCTestCase {
    private var viewModel: PostsViewModel!
    private var navigator: PostsNavigatorMock!
    private var useCase: PostsUseCaseMock!
    
    private var input: PostsViewModel.Input!
    private var output: PostsViewModel.Output!
    
    private var cancelBag: CancelBag!
    
    private let loadTrigger = PassthroughSubject<Void, Never>()
    private let selectPostTrigger = PassthroughSubject<IndexPath, Never>()
    private let searchTextTrigger = PassthroughSubject<String, Never>()
    
    override func setUp() {
        super.setUp()
        navigator = PostsNavigatorMock()
        useCase = PostsUseCaseMock()
        cancelBag = CancelBag()
        viewModel = PostsViewModel(navigator: navigator, useCase: useCase)
        
        input = PostsViewModel.Input(loadTrigger: loadTrigger.eraseToAnyPublisher(),
                                            searchTextTrigger: searchTextTrigger.eraseToAnyPublisher(),
                                            selectPostTrigger: selectPostTrigger.eraseToAnyPublisher())
        output = viewModel.transform(input, cancelBag)
    }
    
    func test_load_post_list_fromDB_success() {
        let expectation = XCTestExpectation(description: self.debugDescription)

        loadTrigger.send(())
        var expectationPosts = [Post]()

        self.useCase
            .retrievePostFromDBReturnValue.sink { _ in } receiveValue: { posts in
                expectationPosts = posts
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssert(self.useCase.retrievePostFromDBCalled)
        XCTAssertTrue(expectationPosts.count == 2)
    }
    
    func test_load_post_list_fromAPI_success() {
        let expectation = XCTestExpectation(description: self.debugDescription)

        loadTrigger.send(())
        
        var expectationPosts = [Post]()
        
        self.useCase
            .getPostsReturnValue.sink { _ in } receiveValue: { posts in
                expectationPosts = posts
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssert(self.useCase.getPostsCalled)
        XCTAssertTrue(expectationPosts.count == 2)
    }
    
    func test_save_post_list_toDB_success() {
        let expectation = XCTestExpectation(description: self.debugDescription)

        loadTrigger.send(())
        
        var expectationSavePosts = false
        
        self.useCase
            .savePostsToDBReturnValue.sink { _ in } receiveValue: { success in
                expectationSavePosts = success
                expectation.fulfill()
            }
            .store(in: cancelBag)
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertTrue(expectationSavePosts)
        XCTAssert(self.useCase.savePostsToDBCalled)
    }
    
    func test_selectPostTrigger_toPostDetail() {
        let expectation = XCTestExpectation(description: self.debugDescription)

        loadTrigger.send(())
        self.selectPostTrigger.send(IndexPath(item: 0, section: 0))

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssert(self.navigator.toPostDetailCalled)
    }
}
