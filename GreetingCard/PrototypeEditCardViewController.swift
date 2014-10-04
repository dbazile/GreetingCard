//
//  PrototypeEditCardViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/3/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class PrototypeEditCardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	let SEGUE_EDIT_SCENE = "EditScene"
	let REUSE_IDENTIFIER = "SceneCell"
	let TAG_SCENE_INDEX = 100
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var card : Card? = DataUtility.LoadCards()[0]
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let destinationController = segue.destinationViewController as EditSceneViewController
		let index = collectionView.indexPathForCell(sender as UICollectionViewCell)!.item
		destinationController.scene = self.card!.scenes[index]
	}
	
	// MARK: UICollectionViewDataSource
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return card!.scenes.count + 21
	}
	
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath) as UICollectionViewCell
		let index = indexPath.item
		
		// Configure the cell
		cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
		
		let label = cell.viewWithTag(TAG_SCENE_INDEX)! as UILabel
		
		if (index < self.card!.scenes.count) {
			label.text = "\(indexPath.item)"
		} else {
			label.text = "+"
			cell.alpha = 0.2
		}
		
		return cell
	}
	
	func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
		self.performSegueWithIdentifier(SEGUE_EDIT_SCENE, sender: self.collectionView!.cellForItemAtIndexPath(indexPath))
		return true
	}


}
