//
//  EditCardViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/3/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class EditCardViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	let SEGUE_EDIT_SCENE = "EditScene"
	let REUSE_IDENTIFIER = "SceneCell"
	let TAG_SCENE_INDEX = 100
	
	var card : Card? = DataUtility.LoadCards()[0]
	
	@IBOutlet weak var cardTitle: UITextField!
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		cardTitle.text = card?.title
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let destinationController = segue.destinationViewController as EditSceneViewController
		let index = collectionView.indexPathForCell(sender as UICollectionViewCell)!.item

		if (index < card?.scenes.count) {
			destinationController.scene = self.card!.scenes[index]
		} else {
			destinationController.scene = generateScene()
		}
	}
	
	// MARK: UICollectionViewDataSource
	
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		// Return an extra cell to account for the 'New Scene' button
		return card!.scenes.count + 1
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

	private func generateScene() -> Scene
	{
		return Scene(caption: "", backgroundColor: nil, foregroundColor: nil, layers: [])
	}
	
	@IBAction func titleDidChange(sender: UITextField) {
		println("Title changed to '\(sender.text)'")
	}
}
