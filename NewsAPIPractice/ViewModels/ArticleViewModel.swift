//
//  ArticleViewModel.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/11/24.
//

import Foundation
import UIKit

// responsible for rendering views in cells

class ArticleViewModel {
  
  // keep trck
  let articleTitle: String?
  let articleAuthor: String?
  let articleDescription: String?
  let articleUrlToImage: URL?
  let articleUrl: URL?
  
  var articleImage: UIImage?
  
  // DI - Dependency Injection
  init(article: Article) {
    self.articleTitle = article.title
    self.articleAuthor = article.author
    self.articleDescription = article.description
    self.articleUrlToImage = article.urlToImage
    self.articleUrl = URL(string: article.url ?? "")
    self.articleImage = UIImage(named: "placeholder")
    
    // Asynchronously load the image
    if let imageUrlString = article.urlToImage {
      print(imageUrlString)
      loadImage(from: imageUrlString)
    }
    
  }
  
  private func loadImage(from articleURL: URL?) {
    guard let url = articleURL else {
      print("Invalid image URL.")
      return
    }
    
    // Fetch image asynchronously
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard var self = self else { return }
      
      if let error = error {
        print("Failed to load image: \(error)")
        return
      }
      
      guard let data = data, let image = UIImage(data: data) else {
        print("Failed to decode image data.")
        return
      }
      
      // Update the image on the main thread
      DispatchQueue.main.async {
        self.articleImage = image
      }
    }.resume()
  }
  
}
