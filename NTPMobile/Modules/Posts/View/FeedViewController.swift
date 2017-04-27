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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell")
        
        guard let post = self.post(at: indexPath) else {
            return cell!
        }
        
        cell?.textLabel?.text = post.text
        cell?.detailTextLabel?.text = "\(post.timestamp)"
        
        return cell!
    }
}
