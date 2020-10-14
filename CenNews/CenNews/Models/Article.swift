//
//  Article.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import Foundation

struct Article: Codable {
    let title: String?
    let author: String?
    let imageUrl: String?
    let publishedAt: String?
    let content: String?
    let source: Source?
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case title, author, imageUrl = "urlToImage", publishedAt, content = "description", source, url
    }
}
