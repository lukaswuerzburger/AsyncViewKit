//
//  AsyncViewController+FailureResolution.swift
//  AsyncViewController
//
//  Created by Lukas Würzburger on 10.05.20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import UIKit

extension AsyncViewController {
    
    public enum FailureResolution {
        case showViewController(UIViewController)
        case custom((AsyncViewController<VC, T, E>) -> Void)
    }
}
