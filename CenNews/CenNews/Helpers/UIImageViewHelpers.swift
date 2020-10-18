//
//  UIImageViewHelpers.swift
//  CenNews
//
//  Created by Bell KunG on 15/10/2563 BE.
//

import Kingfisher
import UIKit

typealias ImageDownloaderCompletion = (Bool) -> ()

extension UIImageView {
    func setImage(urlString: String?, placeholderImage: UIImage? = #imageLiteral(resourceName: "img-placeholder"), completion: ImageDownloaderCompletion? = nil) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completion?(false)
            return
        }
        
        kf.setImage(with: url, placeholder: placeholderImage, options: [.transition(.fade(0.3))], completionHandler: { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success:
                completion?(true)
            case .failure:
                completion?(false)
            }
        })
    }
}
