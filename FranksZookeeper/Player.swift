//
//  Player.swift
//  FranksZookeeper
//
//  Created by Daniel Wagner-Hall on 2016-01-05.
//  Copyright © 2016 Daniel Wagner-Hall. All rights reserved.
//

import Foundation

public class Player : Hashable, CustomStringConvertible {
    let name: String
    var scores: [Int]

    init(name: String) {
        self.scores = [Int]()
        self.name = name
    }

    public var score: Int {
        return self.pastScore(0)
    }

    public func pastScore(roundsToSkip: Int) -> Int {
        var scores = self.scores
        if roundsToSkip > scores.count {
            return 0
        }
        for var i = 0; i < roundsToSkip; ++i {
            scores.removeLast()
        }
        return scores.reduce(0, combine: +)
    }

    // Note that hashValue ignores scores whereas == does not
    public var hashValue: Int {
        return self.name.hashValue
    }

    public var description: String {
        return self.name
    }
}

public func ==(lhs: Player, rhs: Player) -> Bool {
    return lhs.name == rhs.name && lhs.score == rhs.score
}
