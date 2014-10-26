//
//  EditSceneToolbarViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/4/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class EditSceneToolbarViewController : UIViewController
{
	private var _index = -1
	
	var delegate : EditSceneToolbarDelegate?

	///
	/// Layer Index Property
	///   Allows for automatically synchronizing the toolbar as the underlying
	///   data is changed externally
	///
	var layerIndex : Int {
		get { return _index }
		set {
			_index = newValue
			synchronize()
		}
	}

	///
	/// Synchronize all input fields and labels before showing the view
	///
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		synchronize()
	}


	// MARK: - INTERFACE BUILDER /////////////////////////////////////////////////

	@IBOutlet weak var inputCaption    : UITextField!
	@IBOutlet weak var inputLeft       : UISlider!
	@IBOutlet weak var inputOpacity    : UISlider!
	@IBOutlet weak var inputRotation   : UISlider!
	@IBOutlet weak var inputScale      : UISlider!
	@IBOutlet weak var inputTop        : UISlider!
	@IBOutlet weak var labelLayerIndex : UILabel!
	@IBOutlet weak var labelLeft       : UILabel!
	@IBOutlet weak var labelOpacity    : UILabel!
	@IBOutlet weak var labelRotation   : UILabel!
	@IBOutlet weak var labelScale      : UILabel!
	@IBOutlet weak var labelTop        : UILabel!

	/// EventHandler: Executes when the caption was changed
	@IBAction func didChangeCaption(sender:UITextField)
	{
		delegate?.toolbar(self, didChangeCaption:sender.text)
	}

	/// EventHandler: Executes when the X value changes
	@IBAction func didChangeLeft(sender:UISlider)
	{
		delegate?.toolbar(self, didChangeLeft:Int(sender.value))
		format(integer:sender, onto:labelLeft)
	}

	/// EventHandler: Executes when the opacity value changes
	@IBAction func didChangeOpacity(sender:UISlider)
	{
		delegate?.toolbar(self, didChangeOpacity:Float(sender.value))
		format(percentage:sender, onto:labelOpacity)
	}

	/// EventHandler: Executes when the rotation value changes
	@IBAction func didChangeRotation(sender:UISlider)
	{
		delegate?.toolbar(self, didChangeRotation:Int(sender.value))
		format(degrees:sender, onto:labelRotation)
	}

	/// EventHandler: Executes when the scale value changes
	@IBAction func didChangeScale(sender:UISlider)
	{
		delegate?.toolbar(self, didChangeScale:Float(sender.value))
		format(percentage:sender, onto:labelScale)
	}

	/// EventHandler: Executes when the Y value changes
	@IBAction func didChangeTop(sender:UISlider)
	{
		delegate?.toolbar(self, didChangeTop:Int(sender.value))
		format(integer:sender, onto:labelTop)
	}

	/// EventHandler: Executes when the 'layer delete' button is clicked
	@IBAction func didClickLayerDeleteButton()
	{
		delegate?.toolbar(self, didClickLayerDeleteButton:true)
	}

	/// EventHandler: Executes when the 'layer down' button is clicked
	@IBAction func didClickLayerDownButton()
	{
		delegate?.toolbar(self, didClickLayerDownButton:true)
	}

	/// EventHandler: Executes when the 'layer picker' button is clicked
	@IBAction func didClickLayerPickerButton()
	{
		delegate?.toolbar(self, didClickLayerPickerButton:true)
	}

	/// EventHandler: Executes when the 'layer up' button is clicked
	@IBAction func didClickLayerUpButton()
	{
		delegate?.toolbar(self, didClickLayerUpButton:true)
	}


	// MARK: - HELPER METHODS ////////////////////////////////////////////////////

	///
	/// Sets an degree-formatted value to the given label
	///
	private func format(degrees field:UISlider, onto label:UILabel)
	{
		let result = Int(ceil(field.value))
		label.text = "\(result)º"
	}

	///
	/// Sets an integer-formatted value to the given label
	///
	private func format(integer field:UISlider, onto label:UILabel)
	{
		let result = Int(ceil(field.value))
		label.text = String(result)
	}

	///
	/// Sets an percentage-formatted value to the given label
	///
	private func format(percentage field:UISlider, onto label:UILabel)
	{
		let result = Int(ceil(field.value * 100))
		label.text = "\(result)%"
	}

	///
	/// Syncs each label and field to its corresponding value according to the
	/// delegate/datasource.
	///
	private func synchronize()
	{
		// Read the initial data values from the delegate/datasource
		if (nil != self.delegate) {
			let delegate = self.delegate!

			inputCaption.text   = String(delegate.toolbar(self, initialCaptionValue:String(inputCaption.text)))
			inputRotation.value = Float(delegate.toolbar(self, initialRotationValue:Int(inputRotation.value)))
			inputOpacity.value  = Float(delegate.toolbar(self, initialOpacityValue:Float(inputOpacity.value)))
			inputScale.value    = Float(delegate.toolbar(self, initialScaleValue:Float(inputScale.value)))
			inputTop.value      = Float(delegate.toolbar(self, initialTopValue:Int(inputTop.value)))
			inputLeft.value     = Float(delegate.toolbar(self, initialLeftValue:Int(inputLeft.value)))
		}

		// Set the layer index caption
		labelLayerIndex.text = String(layerIndex + 1)

		// Trigger all of the 'didChange' event handlers
		didChangeRotation(inputRotation)
		didChangeOpacity(inputOpacity)
		didChangeScale(inputScale)
		didChangeTop(inputTop)
		didChangeLeft(inputLeft)
	}
}
