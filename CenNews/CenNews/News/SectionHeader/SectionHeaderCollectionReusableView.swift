//
//  SectionHeaderCollectionReusableView.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 17/10/2563 BE.
//

import UIKit

final class SectionHeaderCollectionReusableView: UICollectionReusableView {
    static let nib = UINib(nibName: "SectionHeaderCollectionReusableView", bundle: nil)
    static let identifier = "SectionHeaderCollectionReusableView"
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    
    static var sizingView: SectionHeaderCollectionReusableView = {
        return nib.instantiate(withOwner: nil, options: nil).first as! SectionHeaderCollectionReusableView
    }()
    
    func configureView(title: String, subTitle: String? = nil) {
        titleLabel.text = title
        
        if let subTitle = subTitle, !subTitle.isEmpty {
            subTitleLabel.text = subTitle
            subTitleLabel.isHidden = false
        } else {
            subTitleLabel.isHidden = true
        }
    }
}
