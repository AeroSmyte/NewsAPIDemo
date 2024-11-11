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
    var name: String?
}

struct Article: Decodable {
  var source: Source
  var author: String?
  var title: String?
  var description: String?
  var url: String? // TODO: Update to URL type.
  var urlToImage: URL? // TODO: Update to URL type.
  var publishedAt: String? // TODO: Update to Date type.
}

