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

    var collectionView: UICollectionView?

    required init(game: Game) {
        self.game = game
        self.outPlayers = [Player]()

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

        let cellWidth = self.cellWidth
        let tableWidth = (self.game.round == 0 ? cellWidth : 2 * cellWidth) + 40
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
        let player = self.game.players[indexPath.item]

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let button = UIButton(frame: CGRectMake(0, 0, self.cellWidth, 50))
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.block_setAction({ sender in self.togglePlayerOut(button, player: player)})

        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        cell.contentView.addSubview(button)

        var title = player.name
        if self.game.round > 0 {
            title += " (" + String(player.score) + ")"
        }
        if self.outPlayers.contains(player) {
            title += " (" + self.nth(self.outPlayers.indexOf(player)!)! + " out)"
            cell.backgroundColor = UIColor.greenColor()
        } else {
            cell.backgroundColor = UIColor.lightGrayColor()
        }
        button.setTitle(title, forState: .Normal)
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
                self.presentViewController(new, animated: false, completion: nil)
                return
            }
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
