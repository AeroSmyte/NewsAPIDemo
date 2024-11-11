//
//  ViewController.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/10/24.
//

import UIKit

class ViewController: UIViewController {
  
  private var articles : [Article] = []
  
  // MARK: Properties
  lazy var tableview : UITableView = {
    let tv = UITableView()
    tv.backgroundColor = .appBackground
    tv.allowsSelection = true
    tv.rowHeight = 100
    tv.separatorStyle = .none
    tv.register(CustomNewsCell.self, forCellReuseIdentifier: CustomNewsCell.indentifier)
    return tv
  }()
  
  // MARK: init
  override func viewDidLoad() {
    super.viewDidLoad()
    configureUIComponents()
    fetchArticles()
    
    self.tableview.delegate = self
    self.tableview.dataSource = self
    
    // Do any additional setup after loading the view.
  }
  
  // MARK: - Networking
  func fetchArticles() {
    NetworkHandler.shared.fetchArticles { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }  // Unwrap self safely
        switch result {
        case .success(let fetchedArticles):
          self.articles = fetchedArticles
          // Filter out articles with "[Removed]" in the title or content
          self.articles = fetchedArticles.filter { article in
            !(article.title?.contains("[Removed]") ?? false)
          }
          // Only reload the table view if there are articles to display
          if !fetchedArticles.isEmpty {
            
            self.tableview.reloadData()
          }
        case .failure(let error):
          print("Error fetching articles: \(error)")
        }
      }
    }
  }
  
  
  func configureUIComponents() {
    self.navigationItem.title = "NewsAPI"
    
    self.navigationController?.navigationBar.prefersLargeTitles = true
    self.navigationItem.largeTitleDisplayMode = .always
    
    self.view.addSubview(tableview)
    tableview.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
      tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      tableview.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      tableview.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
    ])
    
  }
  
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard indexPath.row < articles.count else {
      // Return an empty cell if the index is out of bounds
      return UITableViewCell()
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomNewsCell.indentifier, for: indexPath) as? CustomNewsCell else {
      fatalError("The Tableview could not dequeue a CustomNewsCell in VC.")
    }
    let article = articles[indexPath.row]
    cell.configure(article: article)
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return articles.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedArticle = articles[indexPath.row]
    
    let detailVC = ArticleDetailViewController(article: selectedArticle)
    
    if let sheet = detailVC.sheetPresentationController {
      sheet.detents = [.medium(), .large()]
      sheet.prefersGrabberVisible = false
    }
    
    present(detailVC, animated: true)
  }
  
}
