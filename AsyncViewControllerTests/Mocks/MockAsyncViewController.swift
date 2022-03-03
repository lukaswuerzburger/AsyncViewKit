//
//  MockAsyncViewController.swift
//  AsyncViewControllerTests
//
//  Created by lwuerzburger on 03.03.22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

import UIKit
import AsyncViewController

class MockAsyncViewController: AsyncViewController<String> {

    enum Call: Equatable {
        case didLoadViewController(_ viewController: UIViewController)
    }

    var calls: [Call] = []

    override func didLoadViewController(_ viewController: UIViewController) {
        super.didLoadViewController(viewController)
        calls.append(.didLoadViewController(viewController))
    }
}
