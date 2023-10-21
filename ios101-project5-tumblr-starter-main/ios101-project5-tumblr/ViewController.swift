// ViewController.swift
// ios101-project5-tumblr

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {
    
    // MARK: - Properties
    var tableView: UITableView!
    var posts: [Post] = []
    
    // For stretch feature: Ability to fetch posts from different blogs
    let blogURLString = "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk"

    // For stretch feature: Pull to refresh
    let refreshControl = UIRefreshControl()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupRefreshControl() // Setting up pull-to-refresh
        fetchPosts()
    }

    // MARK: - Setup Methods
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        
        // Register your custom cell
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        
        view.addSubview(tableView)
        
        // If you're using AutoLayout, set this to false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints to pin the tableView to the entire view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    // For stretch feature: Setting up pull-to-refresh
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(fetchPosts), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        cell.configure(with: post)
        return cell
    }

    // MARK: - API Call
    @objc func fetchPosts() { // Added @objc for the selector
        let url = URL(string: blogURLString)! // Use variable for easier switching
        let session = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                // Decode the JSON data into our data models
                let blog = try JSONDecoder().decode(Blog.self, from: data) // Using Blog struct from Post.swift
                let posts = blog.response.posts

                DispatchQueue.main.async {
                    self?.posts = posts
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing() // End refreshing when data is loaded
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
