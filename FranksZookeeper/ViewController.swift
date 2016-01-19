//
//  ViewController.swift
//  FranksZookeeper
//
//  Created by Daniel Wagner-Hall on 2016-01-05.
//  Copyright © 2016 Daniel Wagner-Hall. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var names: [String]
    var uniqueNames: Set<String>

    var collectionView: UICollectionView?
    var addPlayerButton: UIButton?
    var startGameButton: UIButton?

    required init?(coder aDecoder: NSCoder) {
        self.names = [String]()
        self.uniqueNames = Set<String>()

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let bounds = UIScreen.mainScreen().bounds

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 200, height: 50)
        let collectionView = UICollectionView(frame: CGRectMake(0, 0, bounds.width, bounds.height - 100), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.backgroundColor = UIColor.whiteColor()
        self.collectionView = collectionView

        let addPlayerButton = self.addPlayerButton ?? UIButton()
        addPlayerButton.setTitle("Add player", forState: .Normal)
        addPlayerButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        addPlayerButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        addPlayerButton.frame = CGRectMake(bounds.midX - 200, bounds.maxY - 80, 200, 80)
        addPlayerButton.addTarget(self, action: "addPlayer:", forControlEvents: .TouchUpInside)
        self.addPlayerButton = addPlayerButton

        let startGameButton = self.startGameButton ?? UIButton()
        startGameButton.setTitle("Start game", forState: .Normal)
        startGameButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        startGameButton.setTitleColor(UIColor.grayColor(), forState: .Disabled)
        startGameButton.frame = CGRectMake(bounds.midX, bounds.maxY - 80, 200, 80)
        startGameButton.addTarget(self, action: "startGame:", forControlEvents: .TouchUpInside)
        self.startGameButton = startGameButton

        self.updateButtons()

        self.view.addSubview(collectionView)
        self.view.addSubview(addPlayerButton)
        self.view.addSubview(startGameButton)

    }

    func addPlayer(sender: UIButton!) {
        let alert = UIAlertController(title: "Add player", message: "", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in }
        let addAction = UIAlertAction(title: "Add", style: .Default) { (action) in
            let f = alert.textFields![0] as UITextField
            let v = f.text!
            self.names.append(v)
            self.uniqueNames.insert(v)
            self.updateButtons()
        }
        addAction.enabled = false

        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Player name"

            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                addAction.enabled = textField.text != "" && !self.uniqueNames.contains(textField.text!)
            }
        }

        alert.addAction(cancelAction)
        alert.addAction(addAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }


    func removePlayer(sender: UIButton!) {
        let name = sender.titleLabel!.text!
        let alert = UIAlertController(title: "Remove player", message: name, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in }
        let removeAction = UIAlertAction(title: "Remove", style: .Default) { (action) in
            self.names.removeAtIndex(self.names.indexOf(name)!)
            self.uniqueNames.remove(name)
            self.updateButtons()
        }
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func startGame(sender: UIButton!) {
        let alert = UIAlertController(title: "Sorry!", message: "Not yet implemented", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in }
        alert.addAction(cancelAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func updateButtons() {
        self.startGameButton?.enabled = self.uniqueNames.count > 3
        self.addPlayerButton?.enabled = self.uniqueNames.count < 8
        self.collectionView?.reloadData()
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.names.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        let button = UIButton(frame: CGRectMake(0, 0, 200, 50))
        button.setTitle(self.names[indexPath.item], forState: .Normal)
        button.setTitleColor(UIColor.blackColor(), forState: .Normal)
        button.addTarget(self, action: "removePlayer:", forControlEvents: .TouchUpInside)

        cell.contentView.subviews.forEach({ $0.removeFromSuperview() })
        cell.contentView.addSubview(button)
        cell.backgroundColor = UIColor.lightGrayColor()
        return cell
    }
}
