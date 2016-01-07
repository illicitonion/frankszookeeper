//
//  PlayerTest.swift
//  FranksZookeeper
//
//  Created by Daniel Wagner-Hall on 2016-01-06.
//  Copyright © 2016 Daniel Wagner-Hall. All rights reserved.
//

import XCTest

@testable import FranksZookeeper

class PlayerTest: XCTestCase {
    func testScores_None() {
        let p = Player(name: "Cat")
        XCTAssertEqual(0, p.score)
    }

    func testScores_One() {
        let p = Player(name: "Cat")
        p.scores = [2]
        XCTAssertEqual(2, p.score)
    }

    func testScores_Many() {
        let p = Player(name: "Cat")
        p.scores = [2, 4, 6]
        XCTAssertEqual(12, p.score)
    }
}
