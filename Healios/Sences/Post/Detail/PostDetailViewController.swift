//
//  PostDetailViewController.swift
//  Healios
//
//  Created by Anh Nguyen on 24/08/2021.
//

import UIKit
import Combine

final class PostDetailViewController: UIViewController, BindableType {
    enum Section: Hashable {
        case main
    }

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    // MARK: - Properties
    var viewModel: PostDetailViewModel!
    private let cancelBag = CancelBag()

    private var dataSource: UITableViewDiffableDataSource<Section, Comment>! = nil
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        bindViewModel()
    }
    
    // MARK: - Methods
    private func configView() {
        title = "Post Detail"
        
        tableView.register(ofType: CommentCell.self)
        configureDataSource()
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Comment>(tableView: tableView) {
            (tableView: UITableView, indexPath: IndexPath, comment: Comment) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(ofType: CommentCell.self, at: indexPath)
            cell.configCell(comment)
            return cell
        }
        dataSource.defaultRowAnimation = .fade
    }
    
    func bindViewModel() {
        let input = PostDetailViewModel.Input(loadTrigger: Just(()).eraseToAnyPublisher())
        let output = viewModel.transform(input, cancelBag)
        
        output.$post
            .sink { [weak self] post in
                self?.bindPostData(post: post)
            }
            .store(in: cancelBag)
        
        output.$user
            .sink { [weak self] user in
                self?.bindUserData(user: user)
            }
            .store(in: cancelBag)
        
        output.$comments
            .sink { [weak self] comments in
                self?.bindCommentsData(comments: comments)
            }
            .store(in: cancelBag)
    }
}

// MARK: - Binders
extension PostDetailViewController {
    private func bindPostData(post: Post?) {
        titleLabel.text = post?.title
        bodyLabel.text = post?.body
    }
    
    private func bindUserData(user: User?) {
        DispatchQueue.main.async { [weak self] in
            self?.userNameLabel.text = "By \(user?.name ?? "")"
        }
    }
    
    private func bindCommentsData(comments: [Comment]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Comment>()
        snapshot.appendSections([.main])
        snapshot.appendItems(comments, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
