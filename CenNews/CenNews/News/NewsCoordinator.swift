//
//  NewsCoordinator.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import RxSwift
import UIKit

final class NewsCoordinator: Coordinator {
    private var navigationController: UINavigationController!
    private var searchController: UISearchController!
    private var searchResultViewModel: SearchResultViewModel!
    
    private let disposeBag = DisposeBag()
    
    private var rootViewController: UIViewController {
        return window.rootViewController!
    }
    
    var window: UIWindow
    var childCoordinators = [Coordinator]()
    
    public init(windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
    }
    
    func start() {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.clear], for: .normal)
        setupSearchController()
        
        let newsViewController = NewsViewController.instantiate(with: searchController)
        newsViewController.delegate = self
        navigationController = UINavigationController(rootViewController: newsViewController)
        navigationController.overrideUserInterfaceStyle = .light
        window.rootViewController = navigationController
    }
    
    private func setupSearchController() {
        searchResultViewModel = SearchResultViewModel()
        let searchResultViewController = SearchResultViewController.instantiate(with: searchResultViewModel)
        searchResultViewController.delegate = self
        
        searchController = UISearchController(searchResultsController: searchResultViewController)
        searchController.searchBar.rx.text
            .bind(to: searchResultViewModel.searchTextRelay)
            .disposed(by: disposeBag)
    }
    
    private func showNewsDetail(with article: Article) {
        let newsDetailViewController = NewsDetailViewController.instantiate(with: NewsDetailViewModel(article: article))
        newsDetailViewController.delegate = self
        navigationController.pushViewController(newsDetailViewController, animated: true)
    }
}

// MARK: - NewsViewControllerDelegate
extension NewsCoordinator: NewsViewControllerDelegate {
    func newsViewController(_ newsViewController: NewsViewController, didTap article: Article) {
        showNewsDetail(with: article)
    }
}

// MARK: - SearchResultViewControllerDelegate
extension NewsCoordinator: SearchResultViewControllerDelegate {
    func searchResultViewController(_ searchResultViewController: SearchResultViewController, didTap article: Article) {
        showNewsDetail(with: article)
    }
}

// MARK: - NewsDetailViewControllerDelegate
extension NewsCoordinator: NewsDetailViewControllerDelegate {
    func newsDetailViewController(_ newsDetailViewController: NewsDetailViewController, didTapReadmore url: URL) {
        let webViewController = WebViewController(url: url)
        navigationController.pushViewController(webViewController, animated: true)
    }
}
