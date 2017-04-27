//
//  ContainerSegue.swift
//  NTPiosUI
//
//  Created by Anton Poltoratskyi on 2/9/17.
//  Copyright © 2017 Anton Poltoratskyi. All rights reserved.
//

import UIKit

public struct ContainerSegueIdentifiers {
    public static let left = "LeftContainerSegue"
    public static let right = "RightContainerSegue"
    public static let central = "CentralContainerSegue"
}

public class ContainerSegue: UIStoryboardSegue {
    var panel: ContainerPanel = .central
    public override func perform() {
        guard let container = source as? ContainerViewController else {
            fatalError("Source View Controller must be ContainerViewController type")
        }
        container.set(destination, to: panel)
    }
}

@objc(CentralContainerSegue)
public class CentralContainerSegue: ContainerSegue {
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        panel = .central
    }
}

@objc(LeftContainerSegue)
public class LeftContainerSegue: ContainerSegue {
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        panel = .left
    }
}

@objc(RightContainerSegue)
public class RightContainerSegue: ContainerSegue {
    override init(identifier: String?, source: UIViewController, destination: UIViewController) {
        super.init(identifier: identifier, source: source, destination: destination)
        panel = .right
    }
}
