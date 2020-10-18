//
//  UIViewHelpers.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import UIKit

extension UIView {
    func loadNib(name: UIView.Type) -> UIView {
        let contentView = Bundle.main.loadNibNamed(String(describing: name.self), owner: self, options: nil)?.first as! UIView
        return contentView
    }
    
    func addContentView(_ contentView: UIView) {
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addConstraintToSuperview(contentView: contentView)
    }
    
    private func addConstraintToSuperview(contentView: UIView) {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[contentView]-0-|", options: [], metrics: nil, views: ["contentView": contentView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[contentView]-0-|", options: [], metrics: nil, views: ["contentView": contentView]))
    }
    
    func systemLayoutSizeFitting(width: CGFloat) -> CGSize {
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = width

        let size = self.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.fittingSizeLevel)
        return size
    }

    func systemLayoutSizeFitting(height: CGFloat) -> CGSize {
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.height = height

        let size = self.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: UILayoutPriority.fittingSizeLevel, verticalFittingPriority: UILayoutPriority.required)
        return size
    }
}
