//
//  NewsDetailViewController.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 18/10/2563 BE.
//

import UIKit

protocol NewsDetailViewControllerDelegate: AnyObject {
    func newsDetailViewController(_ newsDetailViewController: NewsDetailViewController, didTapReadmore url: URL)
}

final class NewsDetailViewController: UIViewController {
    @IBOutlet private weak var contentImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet private weak var publishedDateLabel: UILabel!
    @IBOutlet private weak var readMoreButton: UIButton!
    
    private var viewModel: NewsDetailViewModel!
    weak var delegate: NewsDetailViewControllerDelegate?
    
    static func instantiate(with viewModel: NewsDetailViewModel) -> NewsDetailViewController {
        let viewController = UIStoryboard(name: "NewsDetail", bundle: nil).instantiateInitialViewController()
            as! NewsDetailViewController
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commonInit()
    }
    
    private func commonInit() {
        navigationController?.navigationBar.tintColor = UIColor.cenDarkBlue
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareDidTap))
        contentImageView.setImage(urlString: viewModel.contentImageUrl)
        titleLabel.text = viewModel.title
        authorNameLabel.text = viewModel.authorName
        contentLabel.text = viewModel.content
        publishedDateLabel.text = viewModel.publishedDate
        readMoreButton.isHidden = viewModel.url == nil
    }
    
    @IBAction private func readMoreDidTap(_ sender: UIButton) {
        guard let url = viewModel.url else { return }
        delegate?.newsDetailViewController(self, didTapReadmore: url)
    }
    
    @objc private func shareDidTap() {
        guard let url = viewModel.url else { return }
        let activityViewController = UIActivityViewController(activityItems: [viewModel.title, url], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
}
