//
//  EditCardViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/3/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class EditCardViewController: UICollectionViewController, UICollectionViewDelegate {
	let SEGUE_EDIT_SCENE = "EditScene"
	let REUSE_IDENTIFIER = "CardCell"
	let SCENE_FONT_FACE = "Helvetica"
	let SCENE_FONT_SIZE = CGFloat(60)
	
	var card : Card? = DataUtility.LoadCards()[0]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: REUSE_IDENTIFIER)
    }

	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let destinationController = segue.destinationViewController as EditSceneViewController
		let index = self.collectionView!.indexPathForCell(sender as UICollectionViewCell)!.item
		destinationController.scene = self.card!.scenes[index]
	}
	
    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return card!.scenes.count + 1
    }

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath) as UICollectionViewCell
		let index = indexPath.item
		
		// Configure the cell
		cell.backgroundColor = UIColor.blueColor()
		
		let label = UILabel(frame: cell.bounds)
		label.font = UIFont(name: SCENE_FONT_FACE, size: SCENE_FONT_SIZE)
		label.textAlignment = NSTextAlignment.Center
		label.textColor = UIColor.whiteColor()
		
		if (index < self.card!.scenes.count) {
			label.text = "\(indexPath.item)"
		} else {
			label.text = "+"
			cell.alpha = 0.5
		}
		
		cell.addSubview(label)
		
		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		self.performSegueWithIdentifier(SEGUE_EDIT_SCENE, sender: self.collectionView!.cellForItemAtIndexPath(indexPath))
		return true
	}
}
