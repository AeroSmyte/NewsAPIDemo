//
//  NetworkHandler.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/10/24.
//

import Foundation

enum Constants {
  static let baseURL = "https://newsapi.org/v2/top-headlines"
  static let country = "us"
  static let apiKey  = "******************************" // NOTE: If you are pulling this project to test it, you will need to update this value to your own API key. To do so, here is the website: https://newsapi.org/. 
  static var endPoint : String {
    Self.baseURL + "?country=" + Self.country + "&apiKey=" + Self.apiKey
  }
}


class NetworkHandler {
  
  static let shared = NetworkHandler() // creates a shared instance of this class, static makes it so it's a single instance
  
  func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void) {

    guard let url = URL(string: Constants.endPoint) else {
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
