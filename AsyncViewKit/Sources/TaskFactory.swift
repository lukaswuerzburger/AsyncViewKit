//
//  TaskFactory.swift
//  AsyncViewKit
//
//  Created by Lukas Würzburger on 4/24/22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

import Foundation

protocol TaskProvider {
    @discardableResult
    func task(_ operation: @escaping @Sendable () async -> Void) -> Task<Void, Error>
}

class TaskFactory: TaskProvider {

    @discardableResult
    func task(_ operation: @escaping @Sendable () async -> Void) -> Task<Void, Error> {
        return Task(operation: operation)
    }
}
