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
    
    public var loadingViewController: LoadingAnimatable = LoadingViewController()
    private(set) public var successViewController: VC? = nil
    private var destinationViewController: UIViewController?
    
    // MARK: - Variables
    
    public var overridesNavigationItem: Bool = false
    public var fadesInResultingViewAfterLoading: Bool = true
    public var fadesLoadingAnimation: Bool = true
    
    private var loadClosure: (@escaping (Result<T, E>) -> Void) -> Void
    private var successClosure: (T) -> VC
    private var failureClosure: (E) -> FailureResolution

    // MARK: - Initializer
    
    required public init(
        load: @escaping (@escaping (Result<T, E>) -> Void) -> Void,
        success: @escaping (T) -> VC,
        failure: @escaping (E) -> FailureResolution
    ) {
        self.loadClosure = load
        self.successClosure = success
        self.failureClosure = failure
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View Life Cycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addViewController(loadingViewController)
        reload()
    }
    
    // MARK: - View Helpers
    
    private func addDestinationViewController(_ viewController: UIViewController) {
        destinationViewController = viewController
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
        guard fadesInResultingViewAfterLoading else { return }
        viewController.view.alpha = 0
        UIView.animate(withDuration: 0.5) {
            viewController.view.alpha = 1
        }
    }
    
    private func overrideNavigationItemIfNeeded(_ viewController: UIViewController) {
        guard overridesNavigationItem else { return }
        navigationItem.leftBarButtonItems = viewController.navigationItem.leftBarButtonItems
        navigationItem.rightBarButtonItems = viewController.navigationItem.rightBarButtonItems
        navigationItem.title = viewController.navigationItem.title
        navigationItem.titleView = viewController.navigationItem.titleView
    }

    private func removeDestinationViewControllerIfNeeded() {
        destinationViewController?.view.removeFromSuperview()
        destinationViewController?.removeFromParent()
    }
    
    // MARK: - Life Cycle Hooks
    
    open func didLoadViewController(_ viewController: VC) {}
    
    open func didFailLoading(_ error: E) {}
    
    // MARK: - Networking
    
    public func reload() {
        removeDestinationViewControllerIfNeeded()
        loadingViewController.startLoadingAnimation(animated: fadesLoadingAnimation)
        loadClosure { [weak self] result in
            guard let self = self else { return }
            self.loadingViewController.stopLoadingAnimation(animated: self.fadesLoadingAnimation)
            self.handleReload(result: result)
        }
    }
    
    private func handleReload(result: Result<T, E>) {
        switch result {
        case .success(let model):
            let viewController = successClosure(model)
            successViewController = viewController
            didLoadViewController(viewController)
            addDestinationViewController(viewController)
        case .failure(let error):
            didFailLoading(error)
            switch failureClosure(error) {
            case .showViewController(let viewController):
                addDestinationViewController(viewController)
            case .custom(let customCallback):
                customCallback(self)
            }
        }
    }
}
