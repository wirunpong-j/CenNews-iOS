//
//  LoadingView.swift
//  CenNews
//
//  Created by Wirunpong Jaingamlertwong on 18/10/2563 BE.
//

import Lottie
import UIKit

final class LoadingView: UIView {
    private var animationView: AnimationView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        animationView = AnimationView(name: "lottie-news")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundBehavior = .pauseAndRestore
        animationView.loopMode = .loop
        animationView.animationSpeed = 2
        addSubview(animationView)
        
        addConstraints([
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        play()
    }
    
    func play() {
        animationView.play()
    }
    
    func stop() {
        animationView.stop()
    }
}
