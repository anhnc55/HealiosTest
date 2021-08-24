//
//  PostsViewController.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import UIKit
import Combine

final class PostsViewController: UIViewController, BindableType {
    enum Section: Hashable {
        case main
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Properties
    var viewModel: PostsViewModel!
    var cancelBag = CancelBag()
    
    private var dataSource: UITableViewDiffableDataSource<Section, Post>! = nil
    
    private let searchTextTrigger = PassthroughSubject<String, Never>()
    private let selectPostTrigger = PassthroughSubject<IndexPath, Never>()
        
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    // MARK: - Methods
    private func configView() {
        navigationItem.title = "Posts"
            
        tableView.register(ofType: PostCell.self)
        tableView.delegate = self
        configureDataSource()
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Post>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, post: Post) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(ofType: PostCell.self, at: indexPath)
            cell.accessoryType = .disclosureIndicator
            cell.configCell(post)
            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    func bindViewModel() {
        let input = PostsViewModel.Input(
            loadTrigger: Just(()).eraseToAnyPublisher(),
            searchTextTrigger: searchTextTrigger
                .throttle(for: 0.5, scheduler: RunLoop.main, latest: true)
                .eraseToAnyPublisher(),
            selectPostTrigger: selectPostTrigger.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input, cancelBag)
                
        output.$posts
            .sink { self.bindPostToTableView(posts: $0) }
            .store(in: cancelBag)        
    }
}

// MARK: - Binders
extension PostsViewController {
    private func bindPostToTableView(posts: [Post]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Post>()
        snapshot.appendSections([.main])
        snapshot.appendItems(posts, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
        DispatchQueue.main.async {
            self.tableView.isHidden = posts.isEmpty
        }
    }    
}

// MARK: - UITableViewDelegate
extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectPostTrigger.send(indexPath)
    }
}
