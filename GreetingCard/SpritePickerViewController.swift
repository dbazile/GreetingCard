//
//  SpritePickerViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/5/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class SpritePickerViewController: UICollectionViewController {
	
	var agent = RenderingAgent()
	var sprites = DataUtility.LoadLocalSprites()
	var delegate : SpritePickerDelegate?
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return sprites.count
	}
	
	let SPRITE_CELL = "SpriteCell"
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(SPRITE_CELL, forIndexPath: indexPath) as UICollectionViewCell
		
		let path = sprites[indexPath.item]
		
		agent.render(fromPath: path, onto: cell)
		agent.decorate(cell, borderSize:1, borderColor:UIColor(white:1, alpha:1), dashed:false)
		cell.layer.shadowOffset = CGSize(width: 2, height: 2)
		cell.layer.shadowColor = UIColor.blackColor().CGColor
		cell.layer.shadowOpacity = 1
		
		
		return cell
	}
}
