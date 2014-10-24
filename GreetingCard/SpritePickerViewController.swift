//
//  SpritePickerViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/5/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class SpritePickerViewController : UICollectionViewController
{
	private let SPRITE_CELL = "SpriteCell"

	private let agent = RenderingAgent()
	private let sprites = DataUtility.AllLocalSprites

	var delegate : SpritePickerDelegate?
	
	///
	/// Applies the back button styling to the controller's navbar item
	///
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		Decorator.applyBackButton(on: self)
	}

	// MARK: COLLECTIONVIEW SOURCE/DELEGATION //////////////////////////////////

	///
	/// Returns the number of sprites available
	///
	override func collectionView(collectionView:UICollectionView, numberOfItemsInSection section:Int) -> Int
	{
		return sprites.count
	}

	///
	/// Returns the data for a given cell
	///
	override func collectionView(collectionView:UICollectionView, cellForItemAtIndexPath indexPath:NSIndexPath) -> UICollectionViewCell
	{
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SPRITE_CELL, forIndexPath: indexPath) as UICollectionViewCell

		let sprite = sprites[indexPath.item]

		// Render the icon
		agent.render(fromIdentifier:sprite, onto: cell)

		// Add a border around the icon
		agent.decorate(cell, borderSize:1, borderColor:UIColor(white:1, alpha:1), dashed:false)

		cell.layer.shadowOffset = CGSize(width: 2, height: 2)
		cell.layer.shadowColor = UIColor.blackColor().CGColor
		cell.layer.shadowOpacity = 1

		return cell
	}

	///
	/// EventHandler: Executes when a sprite is tapped
	///
	override func collectionView(collectionView:UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
	{
		let sprite = sprites[indexPath.item]
		delegate?.spritePicker(self, didSelectSprite:sprite)
	}
}
