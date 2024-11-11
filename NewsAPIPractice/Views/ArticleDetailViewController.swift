//
//  BottomSheetUIView.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/10/24.
//

import UIKit
import SafariServices

class ArticleDetailViewController: UIViewController {
  
  private var article: Article
  
  private lazy var heroImageView : UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFill
    iv.clipsToBounds = true
    iv.layer.cornerRadius = 12
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  private lazy var listStackView : UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, openURLButton])
    stackView.axis = .vertical
    stackView.spacing = 15
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()
  
  private lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24)
    label.numberOfLines = 0
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 16)
    label.textColor = .white
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var openURLButton : UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("See This Article", for: .normal)
    button.titleLabel?.font = .boldSystemFont(ofSize: 18)
    button.backgroundColor = .white
    button.layer.cornerRadius = 10
    button.setTitleColor(.accent, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  init(article: Article) {
    self.article = article
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    view.backgroundColor = .appBackground
    
    configureUIComponents()
    
    
    titleLabel.text = article.title
    descriptionLabel.text = article.description
    
    if let imageURL = article.urlToImage, let url = URL(string: imageURL) {
      loadHeroImage(from: url)
    }
    
    openURLButton.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
    
  }
  
  func configureUIComponents() {
    view.addSubview(heroImageView)
    view.addSubview(listStackView)
    
    NSLayoutConstraint.activate([
      heroImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      heroImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
      heroImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
      heroImageView.heightAnchor.constraint(equalToConstant: 200),
      
      listStackView.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 20),
      listStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      listStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      listStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -10)
      
    ])
  }
  
  private func loadHeroImage(from url: URL) {
    URLSession.shared.dataTask(with: url) { data, _, _ in
      if let data = data, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.heroImageView.image = image
        }
      }
    }.resume()
  }
  
  @objc private func openWebView() {
    guard let urlString = article.url, let url = URL(string: urlString) else { return }
    let safariVC = SFSafariViewController(url: url)
    present(safariVC, animated: true)
  }
}
