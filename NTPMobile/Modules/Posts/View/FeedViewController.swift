//
//  PostsViewController.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 01.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

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
        ServiceManager.shared.loadPosts(forAppWithId: Constants.appID, offset: 0, count: 50) { posts in
            self.posts = posts
        }
    }
    
    // MARK: - Datasource
    
    func post(at indexPath: IndexPath) -> Post? {
        return posts?[indexPath.row]
    }
}

// MARK: - UITableViewDataSource

extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // FIXME: make dispatcher for cells
        
        let post = self.post(at: indexPath)
        
        if let _ = post?.photoUrl {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCellWithImage") as! PostImageTableViewCell
            cell.setup(with: post!)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTextTableViewCell
            cell.setup(with: post!)
            return cell
        }
        
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
