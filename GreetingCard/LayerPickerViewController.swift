//
//  LayerPickerViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/5/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class LayerPickerViewController: UITableViewController, UITableViewDataSource {
	let SPRITE_PICKER_MODAL = "SpritePickerModal"
	let CAPTION_ADD_NEW_LAYER = "Add New Layer"
	let LAYER_CELL = "LayerCell"
	let INDEX_NEW_LAYER = 0
	let TAG_LABE_LAYERINDEX = 1
	let TAG_ICON_PREVIEW = 2
	
	
	var agent = RenderingAgent()
	var delegate : LayerPickerDelegate?
	var layers : [Layer]?
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return layers!.count + 1
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(LAYER_CELL, forIndexPath: indexPath) as UITableViewCell
		
		let label = cell.viewWithTag(TAG_LABE_LAYERINDEX) as UILabel!
		let canvas = cell.viewWithTag(TAG_ICON_PREVIEW)!
		
		if (INDEX_NEW_LAYER == indexPath.item) {
			label.text = CAPTION_ADD_NEW_LAYER
			label.textColor = UIColor.blackColor()
			
			canvas.backgroundColor = UIColor(white: 0, alpha: 0.15)
			
			let glyph = UILabel()
			glyph.frame = canvas.bounds.rectByOffsetting(dx: 0, dy: -5)
			glyph.text = "+"
			glyph.font = UIFont.boldSystemFontOfSize(60)
			glyph.textColor = UIColor(white: 1, alpha: 1)
			glyph.textAlignment = NSTextAlignment.Center
			glyph.baselineAdjustment = UIBaselineAdjustment.AlignCenters
			canvas.addSubview(glyph)
			
		} else {
			let i = index(indexPath)
			
			label.text = String(i + 1)
			agent.render(layerAsIcon:layers![i], onto:canvas)
		}
		
		return cell
	}
	
	
	
	
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		super.prepareForSegue(segue, sender:sender)
		
		let controller = segue.destinationViewController as SpritePickerViewController
		//controller.delegate = delegate
	}
	
	
	
	
	
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		if (INDEX_NEW_LAYER == indexPath.item) {
			
			//delegate?.layerPicker(self, didRequestNewLayer: true)
			
			self.performSegueWithIdentifier(SPRITE_PICKER_MODAL, sender:nil)
			
		} else {
			delegate?.layerPicker(self, didSelectLayer:index(indexPath))
		}
	}
	
	private func index(indexPath: NSIndexPath) -> Int
	{
		// Reverse the index
		// Not subtracting 1 from the array length to account for the "NEW LAYER" index
		return (self.layers!.count) - indexPath.item
	}
}
