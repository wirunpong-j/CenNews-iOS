//
//  NewsCardCollectionViewCell.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 17/10/2563 BE.
//

import UIKit

final class NewsCardCollectionViewCell: UICollectionViewCell {
    static let nib = UINib(nibName: "NewsCardCollectionViewCell", bundle: nil)
    static let identifier = "NewsCardCollectionViewCell"
    
    static var sizingCell: NewsCardCollectionViewCell = {
        return nib.instantiate(withOwner: nil, options: nil).first as! NewsCardCollectionViewCell
    }()

    @IBOutlet private weak var shadowView: UIView!
    @IBOutlet private weak var roundView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var publishedTimeLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    
    private func commonInit() {
        roundView.layer.cornerRadius = 10
        shadowView.layer.shadowColor = UIColor.cenLightGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 3)
        shadowView.layer.shadowOpacity = 0.75
        shadowView.layer.shadowRadius = 10
    }
    
    func configureCell(with viewModel: NewsCardCollectionViewCellViewModel) {
        imageView.setImage(urlString: viewModel.imageUrl)
        titleLabel.text = viewModel.title
        authorNameLabel.text = viewModel.authorName
        publishedTimeLabel.text = viewModel.publishedTime
    }
}

struct NewsCardCollectionViewCellViewModel {
    let title: String
    let authorName: String
    let imageUrl: String
    let publishedTime: String
    
    init(article: Article) {
        title = article.title ?? "N/A"
        authorName = article.source?.name ?? "N/A"
        imageUrl = article.imageUrl ?? ""
        publishedTime = Date(dateString: article.publishedAt ?? "")?.toDateString(withFormat: .publishedDate) ?? "N/A"
    }
}
