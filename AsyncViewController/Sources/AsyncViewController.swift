//
//  AsyncViewController.swift
//  AsyncViewController
//
//  Created by Lukas Würzburger on 08.05.20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import UIKit

open class AsyncViewController<VC: UIViewController, T, E: Error>: UIViewController {

    public enum FailureResolution {
        case showViewController(UIViewController)
        case custom((AsyncViewController<VC, T, E>) -> Void)
    }
    
    // MARK: - UI Elements
    
    public let activityIndicatorView = UIActivityIndicatorView(style: .gray)
    public let label = UILabel()
    public var successViewController: VC? = nil

    // MARK: - Variables
    
    public var overridesNavigationItem: Bool = false
    public var shouldFadeInViewAfterLoading: Bool = true
    
    private var load: (@escaping (Result<T, E>) -> Void) -> Void
    private var success: (T) -> VC
    private var failure: (E) -> FailureResolution

    // MARK: - Initializer
    
    required public init(
        load: @escaping (@escaping (Result<T, E>) -> Void) -> Void,
        success: @escaping (T) -> VC,
        failure: @escaping (E) -> FailureResolution
    ) {
        self.load = load
        self.success = success
        self.failure = failure
        super.init(nibName: nil, bundle: nil)
        reload()
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
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor, constant: 20),
            label.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 20)
        ])
    }

    // MARK: - View Helpers
    
    private func add(_ viewController: UIViewController) {
        addViewController(viewController)
        animateFadeInIfNeeded(for: viewController)
        overrideNavigationItemIfNeeded(viewController)
    }
    
    private func addViewController(_ viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(viewController)
        view.addSubview(viewController.view)
        NSLayoutConstraint.activate([
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            viewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        viewController.didMove(toParent: self)
    }
    
    private func animateFadeInIfNeeded(for viewController: UIViewController) {
        guard shouldFadeInViewAfterLoading else { return }
        viewController.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            viewController.view.alpha = 1
        }
    }
    
    private func overrideNavigationItemIfNeeded(_ viewController: UIViewController) {
        guard overridesNavigationItem else { return }
        navigationItem.leftBarButtonItem = viewController.navigationItem.leftBarButtonItem
        navigationItem.title = viewController.navigationItem.title
        navigationItem.titleView = viewController.navigationItem.titleView
        navigationItem.rightBarButtonItem = viewController.navigationItem.rightBarButtonItem
    }

    private func remove(_ viewController: UIViewController) {
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    // MARK: - Life Cycle Hooks
    
    open func didLoadViewController(_ viewController: VC) {}
    
    open func didFailLoading(_ error: E) {}
    
    // MARK: - Networking
    
    public func reload() {
        activityIndicatorView.startAnimating()
        children.forEach({ remove($0) })
        load { [weak self] result in
            self?.activityIndicatorView.stopAnimating()
            self?.handleReload(result: result)
        }
    }
    
    private func handleReload(result: Result<T, E>) {
        switch result {
        case .success(let model):
            let viewController = success(model)
            successViewController = viewController
            didLoadViewController(viewController)
            add(viewController)
        case .failure(let error):
            didFailLoading(error)
            switch failure(error) {
            case .showViewController(let viewController):
                add(viewController)
            case .custom(let customCallback):
                customCallback(self)
            }
        }
    }
}
