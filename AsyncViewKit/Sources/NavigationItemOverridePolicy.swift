//
//  NavigationItemOverridePolicy.swift
//  AsyncViewController
//
//  Created by Lukas Würzburger on 10.05.20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import Foundation

public struct NavigationItemOverridePolicy: OptionSet {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    static public let leftBarButtonItems = NavigationItemOverridePolicy(rawValue: 1 << 0)
    static public let title = NavigationItemOverridePolicy(rawValue: 1 << 1)
    static public let rightBarButtonItems = NavigationItemOverridePolicy(rawValue: 1 << 2)

    static public let barButtonItems: NavigationItemOverridePolicy = [.leftBarButtonItems, .rightBarButtonItems]
    static public let all: NavigationItemOverridePolicy = [.leftBarButtonItems, .title, .rightBarButtonItems]
}
