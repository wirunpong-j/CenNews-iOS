//
//  SearchResultViewModel.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 17/10/2563 BE.
//

import Foundation
import RxCocoa
import RxSwift

enum SearchResultSectionType: Int, CaseIterable {
    case news, loadMore
}

final class SearchResultViewModel {
    private let service: NewsService
    private let disposeBag = DisposeBag()
    private let newsListRelay = BehaviorRelay(value: [Article]())
    private let isLoadingRelay = BehaviorRelay(value: false)
    private let errorSubject = PublishSubject<BaseError?>()
    private var canLoadMore = false
    private var pageNumber = 0
    
    let searchTextRelay = BehaviorRelay<String?>(value: nil)
    
    var shouldReload: Driver<Void> {
        return newsListRelay.asDriver().map { _ in }
    }
    
    var isLoading: Driver<Bool> {
        return isLoadingRelay.asDriver().distinctUntilChanged()
    }
    
    var error: Driver<BaseError?> {
        return errorSubject.asDriver(onErrorJustReturn: nil)
    }
    
    init(service: NewsService = NewsRestService()) {
        self.service = service
        bindObservables()
    }
    
    private func bindObservables() {
        searchTextRelay.do(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.isLoadingRelay.accept(true)
            self.canLoadMore = false
            self.newsListRelay.accept([])
        })
        .asDriver(onErrorJustReturn: nil)
        .debounce(.seconds(2))
        .filter({ $0?.isEmpty == false })
        .map({ $0! })
        .asObservable()
        .subscribe(onNext: { [weak self] searchText in
            guard let self = self else { return }
            self.search(searchText: searchText)
        }).disposed(by: disposeBag)
    }
    
    private func search(searchText: String, pageNumber: Int = 1) {
        let form = NewsRequest()
        form.query = searchText
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
    
    func loadMore() {
        guard let searchText = searchTextRelay.value, !searchText.isEmpty else {
            canLoadMore = false
            return
        }
        search(searchText: searchText, pageNumber: pageNumber + 1)
    }
    
    func getArticle(at indexPath: IndexPath) -> Article? {
        switch sectionType(at: indexPath) {
        case .news:
            return newsListRelay.value[indexPath.row]
        case .loadMore:
            return nil
        }
    }
}

// MARK: - ListViewModel
extension SearchResultViewModel: ListViewModel {
    func numberOfSections() -> Int {
        return SearchResultSectionType.allCases.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        switch sectionType(at: IndexPath(item: 0, section: section)) {
        case .news:
            return newsListRelay.value.count
        case .loadMore:
            return canLoadMore ? 1 : 0
        }
    }
    
    func dataForRow(at indexPath: IndexPath) -> Any? {
        return NewsCardCollectionViewCellViewModel(article: newsListRelay.value[indexPath.row])
    }
    
    func sectionType(at indexPath: IndexPath) -> SearchResultSectionType {
        return SearchResultSectionType(rawValue: indexPath.section)!
    }
}
