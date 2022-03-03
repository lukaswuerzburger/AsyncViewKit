//
//  LoadingViewControllerTests.swift
//  AsyncViewControllerTests
//
//  Created by Lukas Würzburger on 13.05.20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import XCTest
import AsyncViewController

class LoadingViewControllerTests: XCTestCase {

    func testTakesArguments() {
        let viewController = LoadingViewController(loadingTitle: "Test Loading")
        XCTAssertEqual(viewController.activityLabel.text, "Test Loading")
    }

    func testAnimationStateChangesWhenStartingOrStopping() {
        let viewController = LoadingViewController()
        XCTAssertFalse(viewController.isAnimating)
        viewController.startLoadingAnimation()
        XCTAssertTrue(viewController.isAnimating)
        viewController.stopLoadingAnimation()
        XCTAssertFalse(viewController.isAnimating)
    }
}
