//
//  BottomSheetUIView.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/10/24.
//

import UIKit

class ArticleDetailViewController: UIViewController {
  
  private var article: Article
  
  private lazy var listStackView : UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
    stackView.axis = .vertical
    stackView.alignment = .center
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Article Title"
    label.font = .systemFont(ofSize: 30)
    label.numberOfLines = 0
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.text = "Article Description"
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .black
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  init(article: Article) {
    self.article = article
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    view.backgroundColor = .purple
    configureUIComponents()
    
    titleLabel.text = article.title
    descriptionLabel.text = article.description
  }
  
  func configureUIComponents() {
    view.addSubview(listStackView)
    
    NSLayoutConstraint.activate([
      listStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
      listStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      listStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//      
//      descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
//      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//      descriptionLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
    ])
  }
  
}
