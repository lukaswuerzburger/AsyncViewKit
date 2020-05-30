//
//  NavigationItemOverridePolicyTests.swift
//  AsyncViewControllerTests
//
//  Created by Lukas Würzburger on 13.05.20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import XCTest
@testable import AsyncViewController

class NavigationItemOverridePolicyTests: XCTestCase {

    func testTakesArguments() {
        let policy = NavigationItemOverridePolicy(rawValue: 1)
        XCTAssertEqual(policy.rawValue, 1)
    }

    func testRawValueMatchesOption() {
        var rawValue: Int
        var policy: NavigationItemOverridePolicy
        rawValue = NavigationItemOverridePolicy.leftBarButtonItems.rawValue
        policy = NavigationItemOverridePolicy(rawValue: rawValue)
        XCTAssertEqual(policy, .leftBarButtonItems)
        rawValue = NavigationItemOverridePolicy.title.rawValue
        policy = NavigationItemOverridePolicy(rawValue: rawValue)
        XCTAssertEqual(policy, .title)
        rawValue = NavigationItemOverridePolicy.rightBarButtonItems.rawValue
        policy = NavigationItemOverridePolicy(rawValue: rawValue)
        XCTAssertEqual(policy, .rightBarButtonItems)
        rawValue = NavigationItemOverridePolicy.barButtonItems.rawValue
        policy = NavigationItemOverridePolicy(rawValue: rawValue)
        XCTAssertEqual(policy, .barButtonItems)
        rawValue = NavigationItemOverridePolicy.all.rawValue
        policy = NavigationItemOverridePolicy(rawValue: rawValue)
        XCTAssertEqual(policy, .all)
    }
}
