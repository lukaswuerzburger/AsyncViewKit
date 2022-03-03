//
//  AsyncViewControllerTests.swift
//  AsyncViewControllerTests
//
//  Created by Lukas Würzburger on 12.05.20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import XCTest
import AsyncViewController

class AsyncViewControllerTests: XCTestCase {

    // MARK: - Tests

    func testSetupDidAssignViewController() {
        let asyncViewController = AsyncViewController<String>(load: { _ in
        }, build: { _ -> UIViewController in
            .init()
        })
        XCTAssertNotNil(asyncViewController)
    }

    func testExecutesLoadingClosureWhenViewDidLoad() {
        let expect = expectation(description: "Loading closure should be called")
        let _: AsyncViewController<String> = presentAsyncViewController(load: { _ in
            expect.fulfill()
        })
        wait(for: [expect], timeout: 1)
    }

    func testNavigationItemOverridePolicyIsSkippedWhenEmpty() {
        let leftBarButtonItem = UIBarButtonItem()
        let title = String()
        let rightBarButtonItem = UIBarButtonItem()
        let viewController = UIViewController()
        viewController.navigationItem.leftBarButtonItem = leftBarButtonItem
        viewController.navigationItem.title = title
        viewController.navigationItem.rightBarButtonItem = rightBarButtonItem
        let asyncViewController: AsyncViewController<String> = presentAsyncViewController(load: { callback in
            callback("Hello")
        }, build: { _ -> UIViewController in
            return viewController
        })
        XCTAssertEqual(viewController, asyncViewController.destinationViewController)
        XCTAssertNotEqual(viewController.navigationItem.leftBarButtonItems, asyncViewController.navigationItem.leftBarButtonItems)
        XCTAssertNotEqual(viewController.navigationItem.title, asyncViewController.navigationItem.title)
        XCTAssertNotEqual(viewController.navigationItem.rightBarButtonItems, asyncViewController.navigationItem.rightBarButtonItems)
        asyncViewController.navigationItemOverridePolicy = .leftBarButtonItems
        asyncViewController.reload()
        XCTAssertEqual(viewController.navigationItem.leftBarButtonItems, asyncViewController.navigationItem.leftBarButtonItems)
        XCTAssertNotEqual(viewController.navigationItem.title, asyncViewController.navigationItem.title)
        XCTAssertNotEqual(viewController.navigationItem.rightBarButtonItems, asyncViewController.navigationItem.rightBarButtonItems)
        asyncViewController.navigationItemOverridePolicy = .title
        asyncViewController.reload()
        XCTAssertEqual(viewController.navigationItem.leftBarButtonItems, asyncViewController.navigationItem.leftBarButtonItems)
        XCTAssertEqual(viewController.navigationItem.title, asyncViewController.navigationItem.title)
        XCTAssertNotEqual(viewController.navigationItem.rightBarButtonItems, asyncViewController.navigationItem.rightBarButtonItems)
        asyncViewController.navigationItemOverridePolicy = .rightBarButtonItems
        asyncViewController.reload()
        XCTAssertEqual(viewController.navigationItem.leftBarButtonItems, asyncViewController.navigationItem.leftBarButtonItems)
        XCTAssertEqual(viewController.navigationItem.title, asyncViewController.navigationItem.title)
        XCTAssertEqual(viewController.navigationItem.rightBarButtonItems, asyncViewController.navigationItem.rightBarButtonItems)
    }

    func testLifeCycleHookGetsCalled() {
        let viewController = UIViewController()
        let mock = presentMockAsyncViewController(result: "Hello", viewController: viewController)
        XCTAssertEqual(mock.calls, [
            .didLoadViewController(viewController)
        ])
    }

    func testLoadingViewStartsLoading() {
        let expect = expectation(description: "Success closure should be called")
        var asyncViewController: AsyncViewController<String>!
        asyncViewController = presentAsyncViewController(load: { callback in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                callback("Hello")
            }
        }, build: { _ -> UIViewController in
            XCTAssertFalse(asyncViewController.loadingViewController.isAnimating)
            expect.fulfill()
            return .init()
        }, autoPresent: false)
        XCTAssertFalse(asyncViewController.loadingViewController.isAnimating)
        asyncViewController.loadView()
        asyncViewController.viewDidLoad()
        XCTAssertTrue(asyncViewController.loadingViewController.isAnimating)
        wait(for: [expect], timeout: 1)
    }

    func testPresentsDestinationViewControllerOnSuccess() {
        let destinationViewController = UIViewController()
        let asyncViewController: AsyncViewController<String> = presentAsyncViewController(load: { callback in
            callback("Hallo")
        }, build: { _ -> UIViewController in
            return destinationViewController
        })
        XCTAssertEqual(asyncViewController.destinationViewController, destinationViewController)
        XCTAssertTrue(asyncViewController.children.contains(destinationViewController))
        XCTAssertTrue(asyncViewController.view.subviews.contains(destinationViewController.view))
    }

    // MARK: - Helper

    @discardableResult func presentAsyncViewController<T>(
        load: @escaping (@escaping (T) -> Void) -> Void,
        build: ((T) -> UIViewController)? = nil,
        autoPresent: Bool = true
    ) -> AsyncViewController<T> {
        let asyncViewController = AsyncViewController(load: { callback in
            load(callback)
        }, build: { object -> UIViewController in
            return build?(object) ?? .init()
        })
        if autoPresent {
            asyncViewController.loadView()
            asyncViewController.viewDidLoad()
        }
        return asyncViewController
    }

    @discardableResult func presentMockAsyncViewController(result: String, viewController: UIViewController = .init()) -> MockAsyncViewController {
        let mockAsyncViewController = MockAsyncViewController(load: { callback in
            callback(result)
        }, build: { _ -> UIViewController in
            viewController
        })
        mockAsyncViewController.loadView()
        mockAsyncViewController.viewDidLoad()
        return mockAsyncViewController
    }
}
