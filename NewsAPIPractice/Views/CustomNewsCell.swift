//
//  CustomNewsCell.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/10/24.
//

import UIKit

class CustomNewsCell: UITableViewCell {
  
  static let indentifier = "NewsCell"
  
  private lazy var labelsStackView: UIStackView = {
    let sv = UIStackView()
    sv.axis = .vertical
//    sv.distribution = .equalSpacing
    sv.alignment = .leading
    sv.spacing = 3
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()
  
  private lazy var authorLabel : UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 10, weight: .thin)
    label.text = "Author Name"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var titleLabel : UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 24, weight: .medium)
    label.textColor = .label
    label.numberOfLines = 0
    label.text = "Article Title"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var descriptionLabel : UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .light)
    label.textColor = .gray
    label.text = "This is a long description of an article."
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var articleImageView : UIImageView = {
    let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    iv.contentMode = .scaleAspectFit
    iv.image = UIImage(systemName: "questionmark")
    iv.tintColor = .purple
    iv.clipsToBounds = true
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  public func configure(article: Article) {
    if let imageUrlString = article.urlToImage,
       let url = URL(string: imageUrlString) {
      fetchImage(from: url) { [weak self] image in
        DispatchQueue.main.async {
          self?.articleImageView.image = image
        }
      }
    } else {
      articleImageView.image = nil  // Set a placeholder if no image URL
    }
    //    self.articleImageView.image = UIImage()
    self.authorLabel.text = article.author
    self.titleLabel.text = article.title
    self.descriptionLabel.text = article.description
  }
  
  // MARK: - Image Fetching
  
  private func fetchImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
    let task = URLSession.shared.dataTask(with: url) { data, _, error in
      guard let data = data, error == nil else {
        completion(nil)
        return
      }
      let image = UIImage(data: data)
      completion(image)
    }
    task.resume()
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupUI() {
    self.contentView.addSubview(articleImageView)
    
    labelsStackView.addArrangedSubview(titleLabel)
    labelsStackView.addArrangedSubview(authorLabel)
    labelsStackView.addArrangedSubview(descriptionLabel)
    
    self.contentView.addSubview(labelsStackView)
    
    NSLayoutConstraint.activate([
      articleImageView.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
      articleImageView.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor),
      articleImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
      
      articleImageView.widthAnchor.constraint(equalToConstant: 90),
      
      labelsStackView.leadingAnchor.constraint(equalTo: self.articleImageView.trailingAnchor, constant: 10),
      labelsStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
      labelsStackView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
      labelsStackView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
      
      
    ])
  }
  
}
