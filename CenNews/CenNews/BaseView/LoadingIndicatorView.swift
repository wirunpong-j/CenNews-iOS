//
//  LoadingIndicatorView.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 18/10/2563 BE.
//

import MBProgressHUD
import RxSwift
import RxCocoa
import UIKit

public class LoadingIndicatorView: ReactiveCompatible {
    private let view: UIView
    
    init(view: UIView) {
        self.view = view
    }
    
    func start() {
        let loading = MBProgressHUD.showAdded(to: view, animated: true)
        loading.mode = .customView
        loading.customView = LoadingView()
        loading.bezelView.style = .solidColor
        loading.bezelView.backgroundColor = .clear
        loading.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    func stop() {
        MBProgressHUD.hide(for: view, animated: true)
    }
}

extension Reactive where Base: LoadingIndicatorView {
    var loading: Binder<Bool> {
        return Binder(self.base) { (indicator, loading) in
            loading ? indicator.start() : indicator.stop()
        }
    }
}

