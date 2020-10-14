//
//  HighlightNewsCollectionViewCellViewModel.swift
//  CenNews
//
//  Created by Bell KunG on 15/10/2563 BE.
//

import Foundation

final class HighlightNewsCollectionViewCellViewModel: ListViewModel {
    private let articles: [Article]
    
    init(articles: [Article]) {
        self.articles = articles
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return articles.count
    }
    
    func dataForRow(at indexPath: IndexPath) -> Any? {
        return HighlightNewsItemCollectionViewCellViewModel(article: articles[indexPath.row])
    }
    
    func sectionType(at indexPath: IndexPath) -> Int {
        return 0
    }
}
