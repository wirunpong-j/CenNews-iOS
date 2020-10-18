//
//  NewsLoadMoreCollectionViewCell.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 17/10/2563 BE.
//

import UIKit

final class NewsLoadMoreCollectionViewCell: UICollectionViewCell {
    static let nib = UINib(nibName: "NewsLoadMoreCollectionViewCell", bundle: nil)
    static let identifier = "NewsLoadMoreCollectionViewCell"
    
    static var sizingCell: NewsLoadMoreCollectionViewCell = {
        return nib.instantiate(withOwner: nil, options: nil).first as! NewsLoadMoreCollectionViewCell
    }()
    
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    func configureCell() {
        activityIndicatorView.startAnimating()
    }
}
