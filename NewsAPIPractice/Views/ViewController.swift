//
//  ViewController.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/10/24.
//

import UIKit

class ViewController: UIViewController, UISearchControllerDelegate {
  
  private var articleViewModels : [ArticleViewModel] = []
  
  private var filteredArticles : [Article] = []
    
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
    
  }
  
  // MARK: - Networking
  func fetchArticles() {
    NetworkHandler.shared.fetchArticles { [weak self] result in
      DispatchQueue.main.async {
        guard let self = self else { return }  // Unwrap self safely
        switch result {
        case .success(let fetchedArticles):
          
          self.articleViewModels = fetchedArticles.map({return ArticleViewModel(article: $0)})
          // Filter out articles with "[Removed]" in the title or content
          self.articleViewModels = self.articleViewModels.filter { article in
            !(article.articleTitle?.contains("[Removed]") ?? false)
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
    self.navigationItem.title = "Only10"
    
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomNewsCell.indentifier, for: indexPath) as? CustomNewsCell else {
      fatalError("The tableview could not dequeue a CustomNewsCell.")
    }
      
    let articleList = /*searchController.isActive ? filteredArticles : */articleViewModels

    guard indexPath.row < articleList.count else {
      // Return an empty cell if the index is out of bounds
      fatalError("Index out of bounds when accessing article list.")
    }
    

    let article = articleList[indexPath.row]
    cell.articleVM = article
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return /*searchController.isActive ? filteredArticles.count :*/ articleViewModels.count
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedArticle = articleViewModels[indexPath.row]
    
    let detailVC = ArticleDetailViewController(articleVM: selectedArticle)
    
    if let sheet = detailVC.sheetPresentationController {
      sheet.detents = [.medium(), .large()]
      sheet.prefersGrabberVisible = false
    }
    
    present(detailVC, animated: true)
  }
  
}
