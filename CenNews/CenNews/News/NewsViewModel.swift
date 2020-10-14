//
//  NewsViewModel.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import Foundation
import RxCocoa
import RxSwift

enum NewsSectionType: Int, CaseIterable {
    case highlight, newsList, loadMore
}

final class NewsViewModel {
    private let service: NewsService
    private let highlightNewsListRelay = BehaviorRelay(value: [Article]())
    private let newsListRelay = BehaviorRelay(value: [Article]())
    private let isLoadingRelay = BehaviorRelay(value: false)
    private let errorSubject = PublishSubject<BaseError?>()
    private var canLoadMore = false
    private var pageNumber = 0
    
    var shouldReload: Driver<Void> {
        return Driver.merge(highlightNewsListRelay.asDriver().map { _ in },
                            newsListRelay.asDriver().map { _ in })
    }
    
    var isLoading: Driver<Bool> {
        return isLoadingRelay.asDriver().distinctUntilChanged()
    }
    
    var error: Driver<BaseError?> {
        return errorSubject.asDriver(onErrorJustReturn: nil)
    }
    
    init(service: NewsService = NewsRestService()) {
        self.service = service
    }
    
    private func getHighlightNews() {
        let form = NewsRequest()
        form.country = "th"
        
        service.getTopHeadlines(with: form) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                self.highlightNewsListRelay.accept(response)
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
            
            self.isLoadingRelay.accept(false)
        }
    }
    
    private func getAllNews(pageNumber: Int = 1) {
        let form = NewsRequest()
        form.query = "ก"
        form.pageSize = 20
        form.pageNumber = pageNumber
        
        service.getAllNews(with: form) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                if response.isEmpty {
                    self.canLoadMore = false
                } else {
                    self.pageNumber = pageNumber
                    self.canLoadMore = true
                }
                
                let list = pageNumber == 1 ? response : self.newsListRelay.value + response
                self.newsListRelay.accept(list)
            case .failure(let error):
                self.errorSubject.onNext(error)
            }
            
            self.isLoadingRelay.accept(false)
        }
    }
    
    func getArticle(at indexPath: IndexPath) -> Article? {
        switch sectionType(at: indexPath) {
        case .highlight:
            return highlightNewsListRelay.value[indexPath.row]
        case .newsList:
            return newsListRelay.value[indexPath.row]
        case .loadMore:
            return nil
        }
    }
    
    func loadMoreNews() {
        getAllNews(pageNumber: pageNumber + 1)
    }
    
    func reloadData() {
        isLoadingRelay.accept(true)
        getHighlightNews()
        getAllNews()
    }
}

extension NewsViewModel: ListViewModel {
    func numberOfSections() -> Int {
        return NewsSectionType.allCases.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        switch sectionType(at: IndexPath(item: 0, section: section)) {
        case .highlight:
            return highlightNewsListRelay.value.isEmpty ? 0 : 1
        case .newsList:
            return newsListRelay.value.count
        case .loadMore:
            return canLoadMore ? 1 : 0
        }
    }
    
    func dataForRow(at indexPath: IndexPath) -> Any? {
        switch sectionType(at: indexPath) {
        case .highlight:
            return HighlightNewsCollectionViewCellViewModel(articles: highlightNewsListRelay.value)
        case .newsList:
            return NewsCardCollectionViewCellViewModel(article: newsListRelay.value[indexPath.row])
        case .loadMore:
            return nil
        }
    }
    
    func sectionType(at indexPath: IndexPath) -> NewsSectionType {
        return NewsSectionType(rawValue: indexPath.section)!
    }
}
