//
//  LoadingAnimatable.swift
//  AsyncViewController
//
//  Created by Lukas Würzburger on 09.05.20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import UIKit

public protocol LoadingAnimatable: UIViewController {
    var isAnimating: Bool { get }
    func startLoadingAnimation()
    func stopLoadingAnimation()
}
