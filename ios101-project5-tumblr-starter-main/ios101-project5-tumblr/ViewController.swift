// ViewController.swift
// ios101-project5-tumblr

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    var tableView: UITableView!
    var posts: [Post] = []
    
    let blogURLString = "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk"

    let refreshControl = UIRefreshControl()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Tumblr Feed"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        setupRefreshControl()
        fetchPosts()
    }

    // MARK: - Setup Methods
    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self  // Set the delegate
        
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }

    
    // MARK: - UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = posts[indexPath.row]
        let detailVC = DetailViewController()
        detailVC.post = post
        
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - API Call
    @objc func fetchPosts() {
        let url = URL(string: blogURLString)!
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
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                let posts = blog.response.posts

                DispatchQueue.main.async {
                    self?.posts = posts
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
