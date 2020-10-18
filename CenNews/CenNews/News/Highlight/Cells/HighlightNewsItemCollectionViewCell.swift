//
//  HighlightNewsItemCollectionViewCell.swift
//  CenNews
//
//  Created by Bell KunG on 14/10/2563 BE.
//

import UIKit

final class HighlightNewsItemCollectionViewCell: UICollectionViewCell {
    static let nib = UINib(nibName: "HighlightNewsItemCollectionViewCell", bundle: nil)
    static let identifier = "HighlightNewsItemCollectionViewCell"
    
    static var sizingCell: HighlightNewsItemCollectionViewCell = {
        return nib.instantiate(withOwner: nil, options: nil).first as! HighlightNewsItemCollectionViewCell
    }()
    
    @IBOutlet private weak var bgView: UIView!
    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    private func commonInit() {
        bgView.layer.cornerRadius = 8
        bgView.clipsToBounds = true
        shadowView.layer.backgroundColor = UIColor.clear.cgColor
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 1)
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowRadius = 4
    }
    
    func configureCell(with viewModel: HighlightNewsItemCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
        authorNameLabel.text = viewModel.authorName
        imageView.setImage(urlString: viewModel.imageUrl)
    }
}

struct HighlightNewsItemCollectionViewCellViewModel {
    let title: String
    let authorName: String
    let imageUrl: String
    
    init(article: Article) {
        self.title = article.title ?? "N/A"
        self.authorName = article.source?.name ?? "N/A"
        self.imageUrl = article.imageUrl ?? ""
    }
}
