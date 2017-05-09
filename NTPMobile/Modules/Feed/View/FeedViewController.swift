//
//  PostsViewController.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 01.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

protocol FeedModuleInput: class {
    func shouldReloadCategory(_ category: Category, filter: Filter)
}

private let pagingCount = 20

class FeedViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    var interactor: FeedInteractor!
    var router: FeedRouter!
    
    var posts: [Post] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    var category: Category?
    var filter: Filter?
    
    var isDataLoading: Bool = false
    var offset: Int = 0
    var hasNextPage: Bool = true
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    // MARK: - Interaction
    
    func loadCategory(_ category: Category,
                      with filter: Filter,
                      offset: Int,
                      count: Int = pagingCount,
                      forceReload: Bool) {
        
        guard forceReload || self.hasNextPage && !self.isDataLoading else {
            return
        }
        
        self.isDataLoading = true
        
        self.interactor.loadCategory(category, filter: filter, offset: offset, count: count) { [weak self] posts in
            self?.posts.append(contentsOf: posts)
            self?.isDataLoading = false
            self?.offset += posts.count
            self?.hasNextPage = posts.count == count
        }
    }
    
    // MARK: - Pagination
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let targetOffset = targetContentOffset.pointee.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        guard maxOffset - targetOffset <= 0 else { return }
        
        if let category = category, let filter = filter {
            self.loadCategory(category, with: filter, offset: self.offset, forceReload: false)
        }
    }
    
    // MARK: - Datasource
    
    func post(at indexPath: IndexPath) -> Post {
        return posts[indexPath.row]
    }
}

// MARK: - FeedModuleInput

extension FeedViewController: FeedModuleInput {
    func shouldReloadCategory(_ category: Category, filter: Filter) {
        self.category = category
        self.filter = filter
        self.offset = 0
        loadCategory(category, with: filter, offset: self.offset, forceReload: true)
    }
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let reuseIdentifier = cellIdentifier(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        return TypeDispatcher.value(cell)
            .dispatch { (cell: PostTableViewCell) in
                cell.delegate = self
                cell.setup(with: self.post(at: indexPath))
            }
            .extract()
    }

    func cellIdentifier(at indexPath: IndexPath) -> String {
        let post = self.post(at: indexPath)
        return post.hasPhoto
            ? PostImageTableViewCell.cellIdentifier
            : PostTextTableViewCell.cellIdentifier
    }
}

// MARK: - UITableViewDelegate

extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = self.post(at: indexPath)
        if !post.hasPhoto {
            return 44
        }
        return UITableViewAutomaticDimension
    }
}

// MARK: - PostTableViewCellDelegate

extension FeedViewController: PostTableViewCellDelegate {
    func postCell(_ cell: PostTableViewCell, whouldUpdateWithBlock block: () -> Void) {
        tableView.update(with: block)
    }
}
