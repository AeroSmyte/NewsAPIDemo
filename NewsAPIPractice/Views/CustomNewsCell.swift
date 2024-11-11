//
//  CustomNewsCell.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/10/24.
//

import UIKit

class CustomNewsCell: UITableViewCell {
  
  static let indentifier = "NewsCell"
  
  private lazy var containerView : UIView = {
    let view = UIView()
    view.backgroundColor = .red
    view.layer.cornerRadius = 8
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.1
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowRadius = 4
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private lazy var authorLabel : UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .light)
    label.textColor = .appText
    label.numberOfLines = 3
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var titleLabel : UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    label.textColor = .appText
    label.numberOfLines = 2
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  private lazy var articleImageView : UIImageView = {
    let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    iv.contentMode = .scaleAspectFit
    iv.image = UIImage(systemName: "questionmark")
    iv.clipsToBounds = true
    iv.layer.cornerRadius = 8
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
    self.authorLabel.text = article.author
    self.titleLabel.text = article.title
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
    
    contentView.addSubview(containerView)
    contentView.backgroundColor = .appBackground
    containerView.backgroundColor = .clear
    containerView.addSubview(articleImageView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(authorLabel)
    
    self.configureUIComponents()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureUIComponents() {
    
    
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
      
      articleImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
      articleImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
      articleImageView.widthAnchor.constraint(equalToConstant: 60),
      articleImageView.heightAnchor.constraint(equalToConstant: 60),
      
      titleLabel.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: 10),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
      titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
      
      authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      authorLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
      authorLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10)
    ])
  }
  
}
