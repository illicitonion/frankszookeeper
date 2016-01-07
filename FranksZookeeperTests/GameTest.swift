//
//  GameTest.swift
//  FranksZookeeper
//
//  Created by Daniel Wagner-Hall on 2016-01-05.
//  Copyright © 2016 Daniel Wagner-Hall. All rights reserved.
//

import XCTest

@testable import FranksZookeeper

class GameTest: XCTestCase {
    func testOneWinner() {
        let p1 = Player(name: "Cat")
        p1.scores = [24]
        let p2 = Player(name: "Peter")
        p2.scores = [8]
        let p3 = Player(name: "Anna")
        p3.scores = [12]
        let p4 = Player(name: "Daniel")
        p4.scores = [19]
        let g = Game(withPlayers: [p1, p2, p3, p4])
        assertSetEquals(Set<Player>([p1]), g.winners)
    }

    func testThreeWinners() {
        let p1 = Player(name: "Cat")
        p1.scores = [24]
        let p2 = Player(name: "Peter")
        p2.scores = [24]
        let p3 = Player(name: "Anna")
        p3.scores = [12]
        let p4 = Player(name: "Daniel")
        p4.scores = [24]
        let g = Game(withPlayers: [p1, p2, p3, p4])
        assertSetEquals(Set<Player>([p1, p2, p4]), g.winners)
    }

    func testOnlyOneAtNinteen() {
        let p1 = Player(name: "Cat")
        p1.scores = [16]
        let p2 = Player(name: "Peter")
        p2.scores = [8]
        let p3 = Player(name: "Anna")
        p3.scores = [12]
        let p4 = Player(name: "Daniel")
        p4.scores = [19]
        let g = Game(withPlayers: [p1, p2, p3, p4])
        assertSetEquals(Set<Player>(), g.winners)
    }

    func testScoreFirstRound() {
        let p1 = Player(name: "Cat")
        let p2 = Player(name: "Peter")
        let p3 = Player(name: "Anna")
        let p4 = Player(name: "Daniel")
        let g = Game(withPlayers: [p1, p2, p3, p4])
        g.scoreFirstRound(p3, p4, p2, p1)
        XCTAssertEqual(p3.score, 4)
        XCTAssertEqual(p4.score, 3)
        XCTAssertEqual(p2.score, 2)
        XCTAssertEqual(p1.score, 0)
    }

    func testScoreSecondRound_positionalOnly() {
        let p1 = Player(name: "Cat")
        let p2 = Player(name: "Peter")
        let p3 = Player(name: "Anna")
        let p4 = Player(name: "Daniel")
        let g = Game(withPlayers: [p1, p2, p3, p4])
        g.scoreFirstRound(p3, p4, p2, p1)
        g.scoreSubsequentRound(
            (player: p3, hedgehogs: 0, lions: 0),
            (player: p4, hedgehogs: 0, lions: 0),
            (player: p2, hedgehogs: 0, lions: 0),
            (player: p1, hedgehogs: 0, lions: 0)
        )
        XCTAssertEqual(p3.score, 7)
        XCTAssertEqual(p4.score, 7)
        XCTAssertEqual(p2.score, 6)
        XCTAssertEqual(p1.score, 3)
    }

    func testScoreSecondRound_positionalAndHedgehogs() {
        let p1 = Player(name: "Cat")
        let p2 = Player(name: "Peter")
        let p3 = Player(name: "Anna")
        let p4 = Player(name: "Daniel")
        let g = Game(withPlayers: [p1, p2, p3, p4])
        g.scoreFirstRound(p3, p4, p2, p1)
        g.scoreSubsequentRound(
            (player: p3, hedgehogs: 0, lions: 0),
            (player: p4, hedgehogs: 1, lions: 0),
            (player: p2, hedgehogs: 4, lions: 0),
            (player: p1, hedgehogs: 0, lions: 0)
        )
        XCTAssertEqual(p3.score, 7)
        XCTAssertEqual(p4.score, 8)
        XCTAssertEqual(p2.score, 7)
        XCTAssertEqual(p1.score, 3)

        assertSetEquals(Set<Partnership>([Partnership(senior: p4, junior: p1), Partnership(senior: p2, junior: p3)]), g.partnerships)
    }

    func testScoreSecondRound_positionalAndHedgehogsAndLions() {
        let p1 = Player(name: "Cat")
        let p2 = Player(name: "Peter")
        let p3 = Player(name: "Anna")
        let p4 = Player(name: "Daniel")
        let g = Game(withPlayers: [p1, p2, p3, p4])
        g.scoreFirstRound(p3, p4, p2, p1)
        g.scoreSubsequentRound(
            (player: p3, hedgehogs: 1, lions: 0),
            (player: p4, hedgehogs: 1, lions: 2),
            (player: p2, hedgehogs: 1, lions: 1),
            (player: p1, hedgehogs: 2, lions: 2)
        )
        XCTAssertEqual(p3.score, 8)
        XCTAssertEqual(p4.score, 10)
        XCTAssertEqual(p2.score, 7)
        XCTAssertEqual(p1.score, 6)

        assertSetEquals(Set<Partnership>([Partnership(senior: p4, junior: p1), Partnership(senior: p3, junior: p2)]), g.partnerships)
    }

    func testPartnerships_even() {
        let p1 = Player(name: "Cat")
        let p2 = Player(name: "Peter")
        let p3 = Player(name: "Anna")
        let p4 = Player(name: "Daniel")
        let g = Game(withPlayers: [p1, p2, p3, p4])

        assertSetEquals(Set<Partnership>([Partnership(only: p1), Partnership(only: p2), Partnership(only: p3), Partnership(only: p4)]), g.partnerships)

        g.scoreFirstRound(p3, p4, p2, p1)
        assertSetEquals(Set<Partnership>([Partnership(senior: p3, junior: p1), Partnership(senior: p4, junior: p2)]), g.partnerships)
    }

    func testPartnerships_odd() {
        let p1 = Player(name: "Cat")
        let p2 = Player(name: "Peter")
        let p3 = Player(name: "Anna")
        let p4 = Player(name: "Daniel")
        let p5 = Player(name: "Mjark")
        let g = Game(withPlayers: [p1, p2, p3, p4, p5])

        assertSetEquals(Set<Partnership>([Partnership(only: p1), Partnership(only: p2), Partnership(only: p3), Partnership(only: p4), Partnership(only: p5)]), g.partnerships)

        g.scoreFirstRound(p3, p4, p5, p2, p1)
        assertSetEquals(Set<Partnership>([Partnership(senior: p3, junior: p1), Partnership(senior: p4, junior: p2), Partnership(only: p5)]), g.partnerships)
    }

    func testTieBreak() {
        let p1 = Player(name: "Cat")
        p1.scores += [4, 2, 3, 4, 5]
        let p2 = Player(name: "Daniel")
        p2.scores += [3, 3, 3, 4, 5]
        let g1 = Game(withPlayers: [p1, p2])
        assertSetEquals(Set<Partnership>([Partnership(senior: p2, junior: p1)]), g1.partnerships)

        let g2 = Game(withPlayers: [p2, p1])
        assertSetEquals(Set<Partnership>([Partnership(senior: p2, junior: p1)]), g2.partnerships)
    }

    func assertSetEquals<T: CustomStringConvertible>(l: Set<T>, _ r: Set<T>) {
        let onlyL = l.subtract(r)
        let onlyR = r.subtract(l)
        var message = "Sets not equal:"
        if !onlyL.isEmpty {
            message += " Only in L: "
            for l in onlyL {
                message += l.description + ", "
            }
        }
        if !onlyR.isEmpty {
            message += " Only in R: "
            for r in onlyR {
                message += r.description + ", "
            }
        }
        XCTAssert(onlyL.isEmpty && onlyR.isEmpty, message)
    }
}
