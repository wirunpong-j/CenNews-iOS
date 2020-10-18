//
//  HighlightNewsCollectionViewCell.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import UIKit

protocol HighlightNewsCollectionViewCellDelegate: AnyObject {
    func highlightNewsCollectionViewCell(_ highlightNewsCollectionViewCell: HighlightNewsCollectionViewCell, didTap indexPath: IndexPath)
}

final class HighlightNewsCollectionViewCell: UICollectionViewCell {
    static let nib = UINib(nibName: "HighlightNewsCollectionViewCell", bundle: nil)
    static let identifier = "HighlightNewsCollectionViewCell"
    
    static func calculateSize(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: width / 16 * 9)
    }
    
    static var sizingCell: HighlightNewsCollectionViewCell = {
        return nib.instantiate(withOwner: nil, options: nil).first as! HighlightNewsCollectionViewCell
    }()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    private let collectionMargin: CGFloat = 16
    private let itemSpacing: CGFloat = 4
    private var currentItem = 0
    
    private var itemWidth: CGFloat {
        return collectionView.frame.width - collectionMargin * 2
    }
    
    private var itemHeight: CGFloat {
        return itemWidth / 16 * 9
    }
    
    private var viewModel: HighlightNewsCollectionViewCellViewModel!
    weak var delegate: HighlightNewsCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    private func commonInit() {
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .red
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.register(HighlightNewsItemCollectionViewCell.nib, forCellWithReuseIdentifier: HighlightNewsItemCollectionViewCell.identifier)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.sectionInset = .zero
            flowLayout.minimumLineSpacing = itemSpacing
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        }
    }
    
    func configureCell(with viewModel: HighlightNewsCollectionViewCellViewModel) {
        self.viewModel = viewModel
        pageControl.numberOfPages = viewModel.numberOfRowsInSection(0)
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension HighlightNewsCollectionViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.highlightNewsCollectionViewCell(self, didTap: indexPath)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel != nil ? viewModel.numberOfSections() : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HighlightNewsItemCollectionViewCell.identifier, for: indexPath) as! HighlightNewsItemCollectionViewCell
        cell.configureCell(with: viewModel.dataForRow(at: indexPath) as! HighlightNewsItemCollectionViewCellViewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth = Float(itemWidth + itemSpacing)
        let targetXContentOffset = Float(targetContentOffset.pointee.x)
        let contentWidth = Float(collectionView.contentSize.width)
        var newPage = Float(pageControl.currentPage)
        
        if velocity.x == 0 {
            newPage = floor((targetXContentOffset - Float(pageWidth) / 2) / Float(pageWidth)) + 1.0
        } else {
            newPage = Float(velocity.x > 0 ? pageControl.currentPage + 1 : pageControl.currentPage - 1)
            if newPage < 0 {
                newPage = 0
            }
            if (newPage > contentWidth / pageWidth) {
                newPage = ceil(contentWidth / pageWidth) - 1.0
            }
        }
        
        pageControl.currentPage = Int(newPage)
        targetContentOffset.pointee = CGPoint(x: CGFloat(newPage * pageWidth), y: targetContentOffset.pointee.y)
    }
}
