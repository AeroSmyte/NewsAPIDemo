//
//  Article.swift
//  NewsAPIPractice
//
//  Created by Lexi McQueen on 11/10/24.
//

import Foundation

struct ArticleResponse: Decodable {
  let articles: [Article]
}

struct Source: Decodable {
    var id: String?
    var name: String?
}

struct Article: Decodable {
  var source: Source
  var author: String?
  var title: String?
  var description: String?
  var url: String?
  var urlToImage: String?
  var publishedAt: String?
}
