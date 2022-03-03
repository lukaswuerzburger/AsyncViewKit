//
//  MockAsyncResultViewController.swift
//  AsyncViewControllerTests
//
//  Created by lwuerzburger on 03.03.22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

import UIKit
import AsyncViewController

class MockAsyncResultViewController: AsyncResultViewController<UIViewController, String, FakeError> {

    enum Call: Equatable {
        case didCallDidLoadViewController(viewController: UIViewController)
        case didCallDidSucceedLoading(viewController: UIViewController)
        case didCallDidFailLoading(error: FakeError)
    }

    var calls: [Call] = []

    override func didLoadViewController(_ viewController: UIViewController) {
        super.didLoadViewController(viewController)
        calls.append(.didCallDidLoadViewController(viewController: viewController))
    }

    override func didSucceedLoading(_ viewController: UIViewController) {
        super.didSucceedLoading(viewController)
        calls.append(.didCallDidSucceedLoading(viewController: viewController))
    }

    override func didFailLoading(_ error: FakeError) {
        super.didFailLoading(error)
        calls.append(.didCallDidFailLoading(error: error))
    }
}
