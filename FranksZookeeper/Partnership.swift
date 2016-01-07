//
//  Partnership.swift
//  FranksZookeeper
//
//  Created by Daniel Wagner-Hall on 2016-01-06.
//  Copyright © 2016 Daniel Wagner-Hall. All rights reserved.
//

import Foundation

public class Partnership: CustomStringConvertible, Hashable {
    var senior: Player
    var junior: Optional<Player>

    init(only: Player) {
        self.senior = only
    }

    init(senior: Player, junior: Player) {
        self.senior = senior
        self.junior = Optional(junior)
    }

    public var hashValue: Int {
        var h = self.senior.hashValue
        if let j = self.junior?.hashValue {
            h ^= j
        }
        return h
    }

    public var description: String {
        if let j = self.junior?.name {
            return "Senior: " + self.senior.name + ", Junior: " + j
        } else {
            return "Just " + self.senior.name
        }
    }
}


public func ==(lhs: Partnership, rhs: Partnership) -> Bool {
    return lhs.senior == rhs.senior && lhs.junior == rhs.junior
}
