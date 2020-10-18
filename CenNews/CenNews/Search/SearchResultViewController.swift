//
//  SearchResultViewController.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 17/10/2563 BE.
//

import RxSwift
import UIKit

protocol SearchResultViewControllerDelegate: AnyObject {
    func searchResultViewController(_ searchResultViewController: SearchResultViewController, didTap article: Article)
}

final class SearchResultViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var loadingBackgroundView: UIView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    private let disposeBag = DisposeBag()
    private var viewModel: SearchResultViewModel!
    
    weak var delegate: SearchResultViewControllerDelegate?
    
    static func instantiate(with viewModel: SearchResultViewModel) -> SearchResultViewController {
        let viewController = UIStoryboard(name: "SearchResult", bundle: nil).instantiateInitialViewController() as! SearchResultViewController
        viewController.viewModel = viewModel
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
        }).disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] isLoading in
            self?.showLoading(isLoading)
        }).disposed(by: disposeBag)
                
        viewModel.error.drive(onNext: { [weak self] error in
            self?.showAlert(message: error?.message)
            self?.showLoading(false)
        }).disposed(by: disposeBag)
    }
    
    private func commonInit() {
        collectionView.register(NewsCardCollectionViewCell.nib, forCellWithReuseIdentifier: NewsCardCollectionViewCell.identifier)
        collectionView.register(NewsLoadMoreCollectionViewCell.nib, forCellWithReuseIdentifier: NewsLoadMoreCollectionViewCell.identifier)
    }
    
    private func showLoading(_ isLoading: Bool) {
        loadingBackgroundView.isHidden = !isLoading
        if isLoading {
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
        }
    }
}

// MARK: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension SearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let article = viewModel.getArticle(at: indexPath) {
            delegate?.searchResultViewController(self, didTap: article)
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
        case .news:
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
            viewModel.loadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        switch viewModel.sectionType(at: indexPath) {
        case .news:
            return NewsCardCollectionViewCell.sizingCell.systemLayoutSizeFitting(width: width)
        case .loadMore:
            return NewsLoadMoreCollectionViewCell.sizingCell.systemLayoutSizeFitting(width: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
