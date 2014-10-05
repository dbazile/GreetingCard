//
//  EditSceneToolbarViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/4/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class EditSceneToolbarViewController: UIViewController {
	let WIDTH = 320
	let HEIGHT = 265
	
	var delegate : EditSceneToolbarDelegate?
	
	// Property for index
	private var _index = -1
	var layerIndex : Int {
		get {
			return _index
		}
		set {
			_index = newValue
			refresh()
		}
	}
	
	@IBOutlet weak var caption: UITextField!
	@IBOutlet weak var left: UISlider!
	@IBOutlet weak var opacity: UISlider!
	@IBOutlet weak var rotation: UISlider!
	@IBOutlet weak var scale: UISlider!
	@IBOutlet weak var top: UISlider!
	@IBOutlet weak var labelLayerIndex: UILabel!
	@IBOutlet weak var labelLeft: UILabel!
	@IBOutlet weak var labelOpacity : UILabel!
	@IBOutlet weak var labelRotation: UILabel!
	@IBOutlet weak var labelScale: UILabel!
	@IBOutlet weak var labelTop: UILabel!
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		refresh()
	}
	
	@IBAction func rotationDidChange(sender: UISlider) {
		degreeUpdate(sender, label: labelRotation)
		delegate?.toolbarEvent(true, rotation: Int(sender.value))
	}
	
	@IBAction func scaleDidChange(sender: UISlider) {
		percentageUpdate(sender, label: labelScale)
		delegate?.toolbarEvent(true, scale: Float(sender.value))
	}
	
	@IBAction func topDidChange(sender: UISlider) {
		integerUpdate(sender, label: labelTop)
		delegate?.toolbarEvent(true, top: Int(sender.value))
	}
	
	@IBAction func leftDidChange(sender: UISlider) {
		integerUpdate(sender, label: labelLeft)
		delegate?.toolbarEvent(true, left: Int(sender.value))
	}
	
	@IBAction func opacityDidChange(sender: UISlider)
	{
		percentageUpdate(sender, label: labelOpacity)
		delegate?.toolbarEvent(true, opacity: Float(sender.value))
	}
	
	@IBAction func layerButtonClicked()
	{
		delegate?.toolbarEvent(true, layerPicker: true)
	}
	
	@IBAction func layerForwardClicked()
	{
		println("clicked layer-forward button")
	}
	
	@IBAction func layerBackwardClicked()
	{
		println("clicked layer-backward button")
	}
	
	@IBAction func deleteLayerClicked()
	{
		println("clicked delete-layer button")
	}
	
	private func refresh()
	{
		if (nil != delegate) {
			self.rotation.value = Float(delegate!.initialRotation())
			self.opacity.value = Float(delegate!.initialOpacity())
			self.scale.value = Float(delegate!.initialScale())
			self.top.value = Float(delegate!.initialTop())
			self.left.value = Float(delegate!.initialLeft())
			self.caption.text = delegate!.initialCaption()
		}
		
		// Set the layer index caption
		self.labelLayerIndex.text = String(self.layerIndex + 1)
		
		// Trigger all of the change event handlers
		rotationDidChange(rotation)
		opacityDidChange(opacity)
		scaleDidChange(scale)
		topDidChange(top)
		leftDidChange(left)
	}
	
	private func integerUpdate(field: UISlider, label: UILabel)
	{
		let result = Int(ceil(field.value))
		label.text = String(result)
	}
	
	private func degreeUpdate(field: UISlider, label: UILabel)
	{
		let result = Int(ceil(field.value))
		label.text = "\(result)º"
	}
	
	private func percentageUpdate(field: UISlider, label: UILabel)
	{
		let result = Int(ceil(field.value * 100))
		label.text = "\(result)%"
	}
}
