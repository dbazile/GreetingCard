//
//  EditCardViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/3/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class EditCardViewController : UIViewController,
                               UICollectionViewDataSource,
                               UICollectionViewDelegate
{
	private let EDIT_SCENE_SEGUE = "EditSceneSegue"
	private let SCENE_CELL       = "SceneCell"
	private let TAG_SCENE_INDEX  = 100
	
	var card : Card? = DataUtility.LoadCards()[0]
	
	///
	/// Sets the card title
	///
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		cardTitle.text = card?.title
	}
	
	///
	/// Intercepts the segue to configure the next view controller
	///
	override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?)
	{
		let destinationController = segue.destinationViewController as EditSceneViewController
		let index = collectionView.indexPathForCell(sender as UICollectionViewCell)!.item

		if (index < card?.scenes.count) {
			destinationController.scene = self.card!.scenes[index]
		} else {
			destinationController.scene = generateScene()
		}
	}
	
	
	// INTERFACE BUILDER ///////////////////////////////////////////////////////
	
	@IBOutlet weak var cardTitle : UITextField!
	@IBOutlet weak var collectionView : UICollectionView!
	
	///
	/// EventHandler: Scene title was changed
	///
	@IBAction func titleDidChange(sender: UITextField)
	{
		println("[editcardvc:titleDidChange: Scene title changed to '\(sender.text)']")
	}

	
	// COLLECTIONVIEW DATASOURCE/DELEGATE //////////////////////////////////////
	
	///
	/// Sets the number of sections
	///
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
	{
		return 1
	}
	
	///
	/// Sets the number of scenes
	///
	func collectionView(collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
	{
		// Return an extra cell to account for the 'New Scene' button
		return card!.scenes.count + 1
	}
	
	///
	/// Configures a specific scene cell
	///
	func collectionView(collectionView:UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SCENE_CELL, forIndexPath: indexPath) as UICollectionViewCell
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

	
	// HELPER METHODS //////////////////////////////////////////////////////////
	
	///
	/// Creates a new Scene to be edited
	///
	private func generateScene() -> Scene
	{
		let scene = DataUtility.createScene()
		card!.scenes.append(scene)
		return scene
	}
}
