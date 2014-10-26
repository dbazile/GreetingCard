//
//  EditSceneViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/3/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class EditSceneViewController : UIViewController,
                                EditSceneToolbarDelegate,
                                LayerPickerDelegate
{
	private let INITIAL_LAYER_INDEX = 0
	private let TOOLBAR_SEGUE       = "ToolbarSegue"
	private let LAYER_PICKER_SEGUE  = "LayerPickerSegue"
	private var _index = 0
	private var _originalHideNavigationOnActivity = false
	private var _originalHideNavigationByDefault = false

	private let agent = RenderingAgent()

	private var toolbarController : EditSceneToolbarViewController?
	var scene : Scene?
	var sceneNumber = -1
	
	///
	/// Focused Layer Property
	///   Returns the layer corresponding to the current focused layer index
	///
	var focusedLayer : Layer? {
		get {
			return (focusedLayerIndex < scene?.layers.count)
				? scene?.layers[focusedLayerIndex]
				: nil
		}
	}

	///
	/// Focused Layer Index Property
	///   Allows the focused layer index to notify the toolbar controller when
	///   updated
	///
	var focusedLayerIndex : Int {
		get { return _index }
		set {
			_index = newValue
			toolbarController!.layerIndex = _index
		}
	}

	///
	/// One-time controller setup
	///
	override func viewDidLoad()
	{
		super.viewDidLoad()

		Decorator.applyBackButton(on:self)
		
		// Set some defaults on the canvas
		agent.normalize(canvas)

		// Select a starting layer
		self.focusedLayerIndex = INITIAL_LAYER_INDEX
	}

	///
	/// Set some things up to facilitate working in the editor
	///
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)

		hideNavigationBar()
		
		sceneIndexLabel.text = "Scene \(sceneNumber)"
		
		render()
	}

	///
	/// Restores previous settings as the display shifts to a new view
	/// controller
	///
	override func viewWillDisappear(animated: Bool)
	{
		super.viewWillDisappear(animated)

		restoreNavigationBar()

		agent.purge(canvas)
	}

	///
	/// Intercepts the segue to configure the next view controllers
	///
	override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?)
	{
		super.prepareForSegue(segue, sender: sender)

		switch (segue.identifier) {
			case TOOLBAR_SEGUE:
				let controller = segue.destinationViewController as EditSceneToolbarViewController
				controller.delegate = self

				// Keep a local reference to the toolbar controller
				self.toolbarController = controller
				break

			case LAYER_PICKER_SEGUE:
				let controller = segue.destinationViewController as LayerPickerViewController
				controller.delegate = self
				controller.layers = scene!.layers
				break

			default:
				break
		}
	}


	// MARK: - INTERFACE BUILDER /////////////////////////////////////////////////

	@IBOutlet weak var canvas: UIView!
	@IBOutlet weak var sceneIndexLabel: UILabel!
	
	@IBAction func didPressBackButton() {
		navigationController?.popViewControllerAnimated(true)
	}


	// MARK: - LAYER PICKER DATASOURCE/DELEGATE //////////////////////////////////

	///
	/// EventHandler: A new layer was created
	///
	func layerPicker(pickerController:LayerPickerViewController, didCreateLayer newLayer:Layer)
	{

		// Add the new layer to the scene
		let scene = self.scene!
		scene.layers.append(newLayer)

		// Select the new layer
		focusedLayerIndex = scene.layers.count - 1

		// Rerender and return to scene editor
		render()
		navigationController!.popToViewController(self, animated: true)
	}

	///
	/// EventHandler: A layer was reordered
	///
	func layerPicker(pickerController:LayerPickerViewController, didMoveIndexFrom oldIndex:Int, to newIndex:Int)
	{
		println("triggered layer-moved event")
	}

	///
	/// EventHandler: A layer was selected
	///
	func layerPicker(pickerController:LayerPickerViewController, didSelectLayer index:Int)
	{
		focusedLayerIndex = index
		navigationController!.popToViewController(self, animated: true)
	}


	// MARK: - TOOLBAR DATASOURCE/DELEGATE ///////////////////////////////////////

	///
	/// EventHandler: The scene caption was changed
	///
	func toolbar(toolbar:UIViewController, didChangeCaption caption:String)
	{
		scene?.caption = caption
		render()
	}

	///
	/// EventHandler: The X value was changed
	///
	func toolbar(toolbar:UIViewController, didChangeLeft left:Int)
	{
		focusedLayer?.left = left
		render()
	}

	///
	/// EventHandler: The opacity value was changed
	///
	func toolbar(toolbar:UIViewController, didChangeOpacity opacity:Float)
	{
		focusedLayer?.opacity = opacity
		render()
	}

	///
	/// EventHandler: The rotation value was changed
	///
	func toolbar(toolbar:UIViewController, didChangeRotation rotation:Int)
	{
		focusedLayer?.rotation = rotation
		render()
	}

	///
	/// EventHandler: The scale value was changed
	///
	func toolbar(toolbar:UIViewController, didChangeScale scale:Float)
	{
		focusedLayer?.scale = scale
		render()
	}

	///
	/// EventHandler: The Y value was changed
	///
	func toolbar(toolbar:UIViewController, didChangeTop top:Int)
	{
		focusedLayer?.top = top
		render()
	}

	///
	/// EventHandler: The 'pick layer' button was clicked
	///
	func toolbar(toolbar:UIViewController, didClickLayerPickerButton:Bool)
	{
		self.performSegueWithIdentifier(LAYER_PICKER_SEGUE, sender:self)
	}

	///
	/// EventHandler: The 'move layer up' button was clicked
	///
	func toolbar(toolbar:UIViewController, didClickLayerUpButton:Bool)
	{
		if (focusedLayerIndex + 1 < scene!.layers.count) {
			scene!.layers.swap(focusedLayerIndex, focusedLayerIndex+1)
			focusedLayerIndex += 1

			render()
		}
	}

	///
	/// EventHandler: The 'move layer down' button was clicked
	///
	func toolbar(toolbar:UIViewController, didClickLayerDownButton:Bool)
	{
		if (scene!.layers.count > 1) {
			if (focusedLayerIndex > 0) {
				scene!.layers.swap(focusedLayerIndex, focusedLayerIndex-1)
				focusedLayerIndex -= 1

				render()
			}
		}
	}

	///
	/// EventHandler: The 'delete layer" button was clicked
	///
	func toolbar(toolbar:UIViewController, didClickLayerDeleteButton:Bool)
	{
		let layers = scene!.layers

		if (layers.count > 0) {
			scene?.layers.remove(focusedLayerIndex)

			if (focusedLayerIndex > 0) {
				focusedLayerIndex -= 1
			}

			render()
		}
	}

	///
	/// Informs the toolbar what the initial value is for
	///
	func toolbar(toolbar:UIViewController, initialCaptionValue defaultValue:String) -> String
	{
		return scene?.caption ?? ""
	}

	///
	/// Informs the toolbar what the initial value is for rotation
	///
	func toolbar(toolbar:UIViewController, initialRotationValue defaultValue:Int) -> Int
	{
		return focusedLayer?.rotation ?? 0
	}

	///
	/// Informs the toolbar what the initial value is for opacity
	///
	func toolbar(toolbar:UIViewController, initialOpacityValue defaultValue:Float) -> Float
	{
		return focusedLayer?.opacity ?? 1.0
	}

	///
	/// Informs the toolbar what the initial value is for scale
	///
	func toolbar(toolbar:UIViewController, initialScaleValue defaultValue:Float) -> Float
	{
		return focusedLayer?.scale ?? 0.5
	}

	///
	/// Informs the toolbar what the initial value is for Y
	///
	func toolbar(toolbar:UIViewController, initialTopValue defaultValue:Int) -> Int
	{
		return focusedLayer?.top ?? 0
	}

	///
	/// Informs the toolbar what the initial value is for X
	///
	func toolbar(toolbar:UIViewController, initialLeftValue defaultValue:Int) -> Int
	{
		return focusedLayer?.left ?? 0
	}


	// MARK: - HELPER METHODS ////////////////////////////////////////////////////

	///
	/// Renders the scene onto the canvas
	///
	private func render()
	{
		agent.render(scene!, onto:canvas, highlighting:focusedLayerIndex)
	}

	///
	/// Sets the navigation bar's visibility to hideable
	///
	private func hideNavigationBar()
	{
		_originalHideNavigationOnActivity = navigationController?.hidesBarsOnTap ?? false
		_originalHideNavigationByDefault = navigationController?.navigationBarHidden ?? false
		navigationController?.hidesBarsOnTap = false
		navigationController?.navigationBarHidden = true
	}

	///
	/// Resets the navigation bar visibility to its initial settings
	///
	private func restoreNavigationBar()
	{
		navigationController?.hidesBarsOnTap = _originalHideNavigationOnActivity
		navigationController?.navigationBarHidden = _originalHideNavigationByDefault
	}
}
