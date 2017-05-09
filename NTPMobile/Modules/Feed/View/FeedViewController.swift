//
//  PostsViewController.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 01.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

protocol FeedModuleInput: class {
    func shouldReloadFeed()
    func shouldReloadCategory(_ category: Category, filter: Filter)
}

private let pagingCount = 50

class FeedViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var interactor: FeedInteractor!
    var router: FeedRouter!
    
    var posts: [Post]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Datasource
    
    func post(at indexPath: IndexPath) -> Post? {
        return posts?[indexPath.row]
    }
}

// MARK: - FeedModuleInput

extension FeedViewController: FeedModuleInput {
    func shouldReloadCategory(_ category: Category, filter: Filter) {
        self.interactor.loadCategory(category, filter: filter, offset: 0, count: pagingCount) { [weak self] posts in
            self?.posts = posts
        }
    }

    func shouldReloadFeed() {
        self.interactor.loadFeed(ownersOnly: false, offset: 0, count: pagingCount) { [weak self] posts in
            self?.posts = posts
        }
    }
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = cellIdentifier(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        guard let post = self.post(at: indexPath) else {
            return cell
        }
        return TypeDispatcher.value(cell)
            .dispatch { (cell: PostTableViewCell) in cell.setup(with: post) }
            .extract()
    }

    func cellIdentifier(at indexPath: IndexPath) -> String {
        let post = self.post(at: indexPath)
        return post?.hasPhoto ?? false
            ? PostImageTableViewCell.cellIdentifier
            : PostTextTableViewCell.cellIdentifier
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let post = self.post(at: indexPath), post.photoUrl == nil {
            return 44
        }
        return UITableViewAutomaticDimension
    }
}
