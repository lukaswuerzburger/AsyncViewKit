//
//  DispatchQueue.swift
//  AsyncViewKit
//
//  Created by Lukas Würzburger on 4/24/22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

import Foundation

protocol DispatchQueueProvider {
    func async(group: DispatchGroup?, qos: DispatchQoS, flags: DispatchWorkItemFlags, execute work: @escaping @convention(block) () -> Void)
}

extension DispatchQueueProvider {

    func async(execute work: @escaping @convention(block) () -> Void) {
        async(group: nil, qos: .unspecified, flags: [], execute: work)
    }
}

extension DispatchQueue: DispatchQueueProvider {}
