//
//  NetworkHandler.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/10/24.
//

import Foundation


class NetworkHandler {
  
  static let shared = NetworkHandler() // creates a shared instance of this class, static makes it so it's a single instance
  
  func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
    let BASE_URL = ""

    guard let url = URL(string: BASE_URL) else {
      return
    }
    
    let request = URLRequest(url: url)
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        print(error)
        return
      }
      
      guard let data = data else { return }
      
      let decoder = JSONDecoder()
      do {
        let articles = try decoder.decode(ArticleResponse.self, from: data)
        print(articles)
        completion(.success(articles.articles))
      } catch {
        completion(.failure(error))
      }
      
    }.resume()
  }
  
}

// don't forget to allow arbitrary loads in info.plist

enum NewsError: Error {
  case invalidURL, invalidResponse, invalidData
}
