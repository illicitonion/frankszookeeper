//
//  UIButton_Block.swift
//  FranksZookeeper
//
//  Created by Daniel Wagner-Hall on 2016-01-21.
//  Copyright © 2016 Daniel Wagner-Hall. All rights reserved.
//

import ObjectiveC
import UIKit

typealias ActionHandler = (sender: UIButton) -> Void

var ActionBlockKey: UInt8 = 0

class ActionBlockWrapper : NSObject {
    var block: ActionHandler

    init(block: ActionHandler) {
        self.block = block
    }
}

extension UIButton {
    func block_setAction(block: ActionHandler) {
        objc_setAssociatedObject(self, &ActionBlockKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        addTarget(self, action: "block_handleAction:", forControlEvents: .TouchUpInside)
    }

    func block_handleAction(sender: UIButton) {
        let wrapper = objc_getAssociatedObject(self, &ActionBlockKey) as! ActionBlockWrapper
        wrapper.block(sender: sender)
    }
}
