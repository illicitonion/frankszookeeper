//
//  Game.swift
//  FranksZookeeper
//
//  Created by Daniel Wagner-Hall on 2016-01-05.
//  Copyright © 2016 Daniel Wagner-Hall. All rights reserved.
//

import Foundation

public class Game {
    var players: [Player]

    init(withPlayers players: [Player]) {
        self.players = players
    }

    public var round: Int {
        if self.players.isEmpty {
            return 0
        }
        return self.players[0].scores.count
    }

    public func scoreFirstRound(orderedPlayers: [Player]) {
        var playersForOrdering = orderedPlayers
        playersForOrdering.removeLast().scores.append(0)
        for (index, player) in playersForOrdering.enumerate() {
            player.scores.append(orderedPlayers.count - index)
        }
    }

    public func scoreSubsequentRound(orderedPlayers: [(player: Player, hedgehogs: Int, lions: Int)]) {
        var playersForOrdering = orderedPlayers
        let last = playersForOrdering.removeLast()

        var dict = Dictionary<Player, (positional: Int, hedgehogs: Int, lions: Int)>()
        dict[last.player] = (0, last.hedgehogs, last.lions)
        for (index, player) in playersForOrdering.enumerate() {
            dict[player.player] = (positional: orderedPlayers.count - index, hedgehogs: player.hedgehogs, lions: player.lions)
        }

        for p in self.partnerships {
            var total = dict[p.senior]!.positional
            if p.junior != nil {
                let junior = dict[p.junior!]!
                total += junior.positional
                score(p.junior!, totalPositional: total, hedgehogs: junior.hedgehogs, lions: junior.lions)
            } else {
                total += 4
            }
            let senior = dict[p.senior]!
            score(p.senior, totalPositional: total, hedgehogs: senior.hedgehogs, lions: senior.lions)
        }
    }

    func score(player: Player, totalPositional: Int, hedgehogs: Int, lions: Int) {
        player.scores.append(totalPositional + (hedgehogs == 0 ? -1 : 0) + (lions > 1 ? lions : 0))
    }

    public var partnerships: [Partnership] {
        if round == 0 {
            return self.players.map({Partnership(only: $0)})
        }
        var ps = [Partnership]()
        var sorted = self.players.sort({
            if $0.score > $1.score {
                return true
            }
            if $0.score < $1.score {
                return false
            }
            // For past rounds, the person with the *lower* score wins, swap the direction of the check
            for var past = 1; ; ++past {
                let left = $0.pastScore(past)
                let right = $1.pastScore(past)
                if left > right {
                    return false
                }
                if right > left {
                    return true
                }
            }
        })

        while !sorted.isEmpty {
            if sorted.count == 1 {
                ps.append(Partnership(only: sorted.removeFirst()))
            } else {
                ps.append(Partnership(senior: sorted.removeFirst(), junior: sorted.removeLast()))
            }
        }
        return ps
    }

    public var winners: Set<Player> {
        var aboveEighteen = 0
        var winners = Set<Player>()
        var maxScore = 18
        for player in self.players {
            let score = player.score
            if score > 18 {
                aboveEighteen++
            }
            if score > maxScore {
                maxScore = score
                winners = Set<Player>([player])
            } else if score == maxScore {
                winners.insert(player)
            }
        }
        if aboveEighteen < 2 {
            return Set<Player>()
        }
        return winners
    }
}
