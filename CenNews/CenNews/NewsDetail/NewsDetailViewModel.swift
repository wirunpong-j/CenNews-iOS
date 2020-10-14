//
//  NewsDetailViewModel.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 18/10/2563 BE.
//

import Foundation

struct NewsDetailViewModel {
    let title: String
    let authorName: String
    let contentImageUrl: String
    let content: String
    let publishedDate: String
    let url: URL?
    
    init(article: Article) {
        title = article.title ?? "N/A"
        authorName = article.source?.name ?? "N/A"
        contentImageUrl = article.imageUrl ?? ""
        content = article.content ?? "-"
        publishedDate = Date(dateString: article.publishedAt ?? "")?.toDateString(withFormat: .publishedDate) ?? "N/A"
        url = URL(string: article.url ?? "")
    }
}
