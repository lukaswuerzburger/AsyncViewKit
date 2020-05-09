//
//  CustomLoadingViewController.swift
//  AsyncViewController-Demo
//
//  Created by Lukas Würzburger on 09.05.20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import UIKit

class CustomLoadingViewController: UIViewController, LoadingAnimatable {
    
    var isAnimating: Bool = false
    
    func startLoadingAnimation(animated: Bool) {
        animate()
    }
    
    func stopLoadingAnimation(animated: Bool) {
        view.layer.removeAllAnimations()
    }
    
    let dot = UIView()
    var centerConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.backgroundColor = .darkGray
        dot.layer.masksToBounds = true
        dot.layer.cornerRadius = 10
        view.addSubview(dot)
        centerConstraint = dot.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -30)
        NSLayoutConstraint.activate([
            centerConstraint,
            dot.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            dot.widthAnchor.constraint(equalToConstant: 20),
            dot.heightAnchor.constraint(equalToConstant: 20)
        ])
        view.layoutIfNeeded()
    }
    
    func animate() {
        centerConstraint.constant = 30
        view.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }) { finished in
            guard finished else { return }
            self.centerConstraint.constant = -30
            self.view.setNeedsUpdateConstraints()
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.view.layoutIfNeeded()
            }) { finished in
                guard finished else { return }
                self.animate()
            }
        }
    }
}
