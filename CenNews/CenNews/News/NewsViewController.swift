//
//  ViewController.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import RxSwift
import UIKit

protocol NewsViewControllerDelegate: AnyObject {
    func newsViewController(_ newsViewController: NewsViewController, didTap article: Article)
}

final class NewsViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private lazy var loadingView = LoadingIndicatorView(view: view)
    private var searchController: UISearchController!
    private let refreshControl = UIRefreshControl()
    private let viewModel = NewsViewModel()
    private let disposeBag = DisposeBag()
    
    weak var delegate: NewsViewControllerDelegate?
    
    static func instantiate(with searchController: UISearchController) -> NewsViewController {
        let viewController = UIStoryboard(name: "News", bundle: nil).instantiateInitialViewController()
            as! NewsViewController
        viewController.searchController = searchController
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
        bindObservables()
    }
    
    private func bindObservables() {
        viewModel.shouldReload.drive(onNext: { [weak self] in
            self?.collectionView.reloadData()
            self?.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(loadingView.rx.loading).disposed(by: disposeBag)
        
        viewModel.error.drive(onNext: { [weak self] error in
            self?.showAlert(message: error?.message)
            self?.refreshControl.endRefreshing()
        }).disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged).asDriver().drive(onNext: { [weak self] in
            self?.viewModel.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.reloadData()
    }
    
    private func commonInit() {
        refreshControl.overrideUserInterfaceStyle = .light
        searchController.searchBar.placeholder = "Search News"
        searchController.searchResultsUpdater = self
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "News"
        navigationItem.searchController = searchController
        
        collectionView.register(SectionHeaderCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderCollectionReusableView.identifier)
        collectionView.register(HighlightNewsCollectionViewCell.nib, forCellWithReuseIdentifier: HighlightNewsCollectionViewCell.identifier)
        collectionView.register(NewsCardCollectionViewCell.nib, forCellWithReuseIdentifier: NewsCardCollectionViewCell.identifier)
        collectionView.register(NewsLoadMoreCollectionViewCell.nib, forCellWithReuseIdentifier: NewsLoadMoreCollectionViewCell.identifier)
        collectionView.refreshControl = refreshControl
        collectionView.reloadData()
    }
}

// MARK: - UISearchResultsUpdating
extension NewsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {}
}

// MARK: - HighlightNewsCollectionViewCellDelegate
extension NewsViewController: HighlightNewsCollectionViewCellDelegate {
    func highlightNewsCollectionViewCell(_ highlightNewsCollectionViewCell: HighlightNewsCollectionViewCell, didTap indexPath: IndexPath) {
        if let article = viewModel.getArticle(at: IndexPath(item: indexPath.item, section: NewsSectionType.highlight.rawValue)) {
            delegate?.newsViewController(self, didTap: article)
        }
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension NewsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let article = viewModel.getArticle(at: indexPath) {
            delegate?.newsViewController(self, didTap: article)
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.sectionType(at: indexPath) {
        case .highlight:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighlightNewsCollectionViewCell.identifier, for: indexPath) as! HighlightNewsCollectionViewCell
            cell.delegate = self
            cell.configureCell(with: viewModel.dataForRow(at: indexPath) as! HighlightNewsCollectionViewCellViewModel)
            return cell
        case .newsList:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCardCollectionViewCell.identifier, for: indexPath) as! NewsCardCollectionViewCell
            cell.configureCell(with: viewModel.dataForRow(at: indexPath) as! NewsCardCollectionViewCellViewModel)
            return cell
        case .loadMore:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsLoadMoreCollectionViewCell.identifier, for: indexPath) as! NewsLoadMoreCollectionViewCell
            cell.configureCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.sectionType(at: indexPath) == .loadMore {
            viewModel.loadMoreNews()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.sectionType(at: indexPath) {
        case .highlight:
            return HighlightNewsCollectionViewCell.calculateSize(width: view.frame.width)
        case .newsList:
            return NewsCardCollectionViewCell.sizingCell.systemLayoutSizeFitting(width: view.frame.width)
        case .loadMore:
            return NewsLoadMoreCollectionViewCell.sizingCell.systemLayoutSizeFitting(width: view.frame.width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch viewModel.sectionType(at: IndexPath(item: 0, section: section)) {
        case .highlight:
            return UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        case .loadMore:
            return UIEdgeInsets(top: 0, left: 0, bottom: 28, right: 0)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderCollectionReusableView.identifier, for: indexPath) as? SectionHeaderCollectionReusableView {
            switch viewModel.sectionType(at: indexPath) {
            case .highlight:
                sectionHeaderView.configureView(title: "Highlights", subTitle: "Highlight News in Thailand")
            case .newsList:
                sectionHeaderView.configureView(title: "Interest News")
            case .loadMore:
                break
            }
            
            return sectionHeaderView
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch viewModel.sectionType(at: IndexPath(item: 0, section: section)) {
        case .highlight:
            return SectionHeaderCollectionReusableView.sizingView.systemLayoutSizeFitting(width: view.frame.width)
        case .newsList:
            return CGSize(width: view.frame.width, height: 40)
        case .loadMore:
            return .zero
        }
    }
}
