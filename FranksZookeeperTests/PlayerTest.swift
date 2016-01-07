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

    func testPastScores_Many() {
        let p = Player(name: "Cat")
        p.scores = [2, 4, 6]
        XCTAssertEqual(12, p.pastScore(0))
        XCTAssertEqual(6, p.pastScore(1))
        XCTAssertEqual(2, p.pastScore(2))
        XCTAssertEqual(0, p.pastScore(3))
        XCTAssertEqual(0, p.pastScore(4))
        XCTAssertEqual(12, p.pastScore(0))
        XCTAssertEqual(12, p.score)
    }
}
