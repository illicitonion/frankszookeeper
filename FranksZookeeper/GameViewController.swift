//
//  GameViewController.swift
//  FranksZookeeper
//
//  Created by Daniel Wagner-Hall on 2016-01-20.
//  Copyright © 2016 Daniel Wagner-Hall. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var game: Game!
    var outPlayers: [Player]
    var personalScores: [Player: (hedgehogs: Int, lions: Int)]

    var collectionView: UICollectionView?

    required init(game: Game) {
        // TODO: Pop view on back button
        self.game = game
        self.outPlayers = [Player]()
        self.personalScores = [Player: (hedgehogs: Int, lions: Int)]()

        super.init(nibName: nil, bundle: nil)
    }

    required init(coder: NSCoder) {
        fatalError("Does not support coder")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let bounds = UIScreen.mainScreen().bounds

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)

        let winners = self.game.winners
        let oneColumn = self.game.round == 0 || !winners.isEmpty

        let cellWidth = self.cellWidth
        let tableWidth = (oneColumn ? cellWidth : 2 * cellWidth) + 40
        layout.itemSize = CGSize(width: cellWidth, height: 50)
        let collectionView = UICollectionView(frame: CGRectMake((bounds.width - tableWidth) / 2, 0, tableWidth, bounds.height - 100), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView = collectionView

        self.view.addSubview(collectionView)
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.game.players.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // TODO: Cache winners and winning order
        let winners = self.game.winners

        var player: Player
        if !winners.isEmpty {
            player = self.game.players.sort({ $0.score > $1.score })[indexPath.item]
        } else if self.game.round == 0 {
            player = self.game.players[indexPath.item]
        } else {
            let partnership = self.game.partnerships[indexPath.item / 2]
            player = indexPath.item % 2 == 0 ? partnership.senior : partnership.junior!
        }

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let button = UIButton(frame: CGRectMake(0, 0, self.cellWidth, 50))
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)

        var title = player.name
        if self.game.round > 0 {
            title += " (" + String(player.score) + ")"
        }

        if winners.isEmpty {
            if self.outPlayers.contains(player) {
                title += " (" + self.nth(self.outPlayers.indexOf(player)!)! + " out)"
                cell.backgroundColor = UIColor.greenColor()
            } else {
                cell.backgroundColor = UIColor.lightGrayColor()
            }
            button.block_setAction({ sender in self.togglePlayerOut(button, player: player)})
        } else if winners.contains(player) {
            cell.backgroundColor = UIColor.blueColor()
        }
        button.setTitle(title, forState: .Normal)

        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        cell.contentView.addSubview(button)

        return cell
    }

    func togglePlayerOut(sender: UIButton!, player: Player) {
        if !self.outPlayers.contains(player) {
            self.outPlayers.append(player)
        } else if self.outPlayers.last == player {
            self.outPlayers.popLast()
        }

        if self.outPlayers.count == self.game.players.count {
            if self.game.round == 0 {
                self.game.scoreFirstRound(self.outPlayers)
                let new = GameViewController(game: self.game)
                self.navigationController?.pushViewController(new, animated: false)
                return
            }
            // TODO: Ask for hedgehogs and lions
            //if self.personalScores.count == self.game.players.count {
                self.game.scoreSubsequentRound(self.outPlayers.map({ (player: $0, hedgehogs: 1, lions: 0) }))
                let new = GameViewController(game: self.game)
                self.navigationController?.pushViewController(new, animated: false)
                return
            //}

        }
        self.collectionView?.reloadData()
    }

    func nth(n: Int) -> String? {
        switch(n) {
        case 0:
            return "first"
        case 1:
            return "second"
        case 2:
            return "third"
        case 3:
            return "fourth"
        case 4:
            return "fifth"
        case 5:
            return "sixth"
        case 6:
            return "seventh"
        case 7:
            return "eighth"
        default:
            return nil
        }
    }

    var cellWidth: CGFloat {
        return self.game.round == 0 ? 200 : 150
    }
}
