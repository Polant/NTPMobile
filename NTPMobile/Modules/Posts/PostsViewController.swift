//
//  PostsViewController.swift
//  VKAuth
//
//  Created by Anton Poltoratskyi on 01.04.17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ServiceManager.shared.loadPosts(for: "iphone", offset: 0, count: 50) { posts in
            self.posts = posts
        }
    }
    
    func post(at indexPath: IndexPath) -> Post? {
        return posts?[indexPath.row]
    }
}

extension PostsViewController: UITableViewDataSource {
    
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
