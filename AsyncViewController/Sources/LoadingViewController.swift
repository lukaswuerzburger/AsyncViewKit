//
//  LoadingViewController.swift
//  AsyncViewController
//
//  Created by Lukas Würzburger on 09.05.20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import UIKit

public class LoadingViewController: UIViewController, LoadingAnimatable {
    
    // MARK: - UI Elements
    
    public let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    public let activityLabel = UILabel()

    // MARK: - Initializer

    public init(loadingTitle: String = "Loading ...") {
        super.init(nibName: nil, bundle: nil)
        activityLabel.text = loadingTitle
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - View Setup
    
    private func setupView() {
        view.backgroundColor = .white
        setupActivityIndicatorView()
        setupLabel()
    }

    private func setupActivityIndicatorView() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicatorView)
        NSLayoutConstraint.activate([
            activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupLabel() {
        activityLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityLabel)
        NSLayoutConstraint.activate([
            activityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityLabel.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 20),
            activityLabel.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -20),
            activityLabel.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 20)
        ])
    }

    // MARK: - Loading Animatable
    
    public var isAnimating: Bool {
        return activityIndicatorView.isAnimating
    }
    
    public func startLoadingAnimation() {
        activityIndicatorView.startAnimating()
    }
    
    public func stopLoadingAnimation() {
        activityIndicatorView.stopAnimating()
    }
}
