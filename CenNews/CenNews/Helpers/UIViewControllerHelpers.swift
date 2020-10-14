//
//  UIViewControllerHelpers.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 17/10/2563 BE.
//

import UIKit

extension UIViewController {
    func showAlert(title: String? = nil, message: String?, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title ?? "CenNews",
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            completion?()
        }))
        
        present(alertController, animated: true)
    }
}
