//
//  LayerPickerViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/5/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class LayerPickerViewController : UITableViewController,
	                              UITableViewDataSource,
	                              SpritePickerDelegate
{
	private let SPRITE_PICKER_SEGUE = "SpritePickerSegue"
	private let LAYER_CELL          = "LayerCell"
	private let ADD_NEW_LAYER       = "Add New Layer"
	private let NEW_LAYER_INDEX     = 0
	private let TAG_LABEL           = 1
	private let TAG_ICON            = 2

	private let agent = RenderingAgent()

	var delegate : LayerPickerDelegate?
	var layers : [Layer]?

	///
	/// One-time controller setup
	///
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Decorator.applyBackButton(on: self)
	}
	
	///
	/// Perform some action whenever the view comes active
	///
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		Decorator.usingEditContext(navigationController)
	}
	
	///
	/// Intercepts the segue to configure the next view controller
	///
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
	{
		super.prepareForSegue(segue, sender:sender)

		// Register as the SpritePicker's delegate
		let controller = segue.destinationViewController as SpritePickerViewController
		controller.delegate = self
	}


	// MARK: - SPRITEPICKER DELEGATION ///////////////////////////////////////////

	///
	/// EventHandler: Executes when a sprite is picked from the sprite picker
	///
	func spritePicker(picker: SpritePickerViewController, didSelectSprite identifier: String)
	{
		let layer = DataUtility.CreateLayer(identifier)

		// Send the new layer to the delegate
		self.delegate?.layerPicker(self, didCreateLayer:layer)
	}


	// MARK: - TABLEVIEW SOURCE/DELEGATION ///////////////////////////////////////

	///
	/// Returns the number of table cells
	///
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return layers!.count + 1
	}

	///
	/// Returns the data for a given table cell
	///
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier(LAYER_CELL, forIndexPath: indexPath) as UITableViewCell

		let label = cell.viewWithTag(TAG_LABEL) as UILabel!
		let canvas = cell.viewWithTag(TAG_ICON)!

		if (NEW_LAYER_INDEX == indexPath.item) {

			// Format the 'new layer' cell
			label.text = ADD_NEW_LAYER
			label.textColor = UIColor.blackColor()
			agent.render(glyph:"+", onto:canvas)

		} else {

			// Format the 'current layer' cell
			let i = index(indexPath)
			label.text = String(i + 1)
			agent.render(layerAsIcon:layers![i], onto:canvas)

		}

		return cell
	}

	///
	/// EventHandler: Executes whenever a cell is tapped
	///
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
	{
		if (NEW_LAYER_INDEX == indexPath.item) {

			// Selected a new layer
			self.performSegueWithIdentifier(SPRITE_PICKER_SEGUE, sender:nil)

		} else {

			// Selected an existing layer
			delegate?.layerPicker(self, didSelectLayer:index(indexPath))

		}
	}


	// MARK: - HELPER METHODS ////////////////////////////////////////////////////

	///
	/// Translates the array index into one that makes more semantic sense from
	/// a user's perspective
	///
	private func index(indexPath: NSIndexPath) -> Int
	{
		// Not subtracting 1 to account for the "NEW LAYER" index
		return (self.layers!.count) - indexPath.item
	}
}
