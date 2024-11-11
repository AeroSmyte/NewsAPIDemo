//
//  ViewController.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/10/24.
//

import UIKit

class ViewController: UIViewController, UISearchControllerDelegate {
  
  private var articles : [Article] = []
  
  private var filteredArticles : [Article] = []
  
  var searchController = UISearchController(searchResultsController: nil)
  
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
    
    filteredArticles = articles
    
    searchController.searchResultsUpdater = self
    searchController.searchBar.sizeToFit()
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search for articles."
    
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = true
    
//    self.tableview.tableHeaderView = searchController.searchBar
    
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

extension ViewController: UISearchBarDelegate, UISearchResultsUpdating {
  
  
  // This method updates filteredData based on the text in the Search Box
  func updateSearchResults(for searchController: UISearchController) {
    if let searchText = searchController.searchBar.text {
      filteredArticles = searchText.isEmpty ? articles : articles.filter { article in
        return article.title!.lowercased().contains(searchText)
      }
      
      self.tableview.reloadData()
    }
  }
  
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = true
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.showsCancelButton = false
    searchBar.text = ""
    searchBar.resignFirstResponder()
  }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomNewsCell.indentifier, for: indexPath) as? CustomNewsCell else {
      fatalError("The tableview could not dequeue a CustomNewsCell.")
    }
      
    let articleList = searchController.isActive ? filteredArticles : articles

    guard indexPath.row < articleList.count else {
      // Return an empty cell if the index is out of bounds
      fatalError("Index out of bounds when accessing article list.")
    }
    

    let article = articleList[indexPath.row]
    cell.configure(article: article)
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return searchController.isActive ? filteredArticles.count : articles.count
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
