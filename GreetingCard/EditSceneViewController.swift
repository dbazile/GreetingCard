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
	let STARTING_LAYER = 0
	let EDIT_SCENE_TOOLBAR = "EditSceneToolbar"
	let LAYER_PICKER_MODAL = "LayerPickerModal"
	let agent = RenderingAgent()
	var toolbarController : EditSceneToolbarViewController?
	var scene : Scene?
	
	// Property
	var focusedLayer : Layer? {
		get {
			return scene?.layers[focusedLayerIndex]
		}
	}

	// Property
	private var _index = 0
	var focusedLayerIndex : Int {
		get {
			return _index
		}
		set {
			_index = newValue
			toolbarController!.layerIndex = _index
		}
	}
	
	@IBOutlet weak var canvas: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		agent.normalize(canvas)
		
		navigationController?.hidesBarsOnTap = true
		navigationController?.navigationBarHidden = true

		self.focusedLayerIndex = STARTING_LAYER
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		render()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		agent.purge(canvas)
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		super.prepareForSegue(segue, sender: sender)
		
		if (EDIT_SCENE_TOOLBAR == segue.identifier) {
			let controller = segue.destinationViewController as EditSceneToolbarViewController
			controller.delegate = self
	
			// Keep a reference to the toolbar controller
			self.toolbarController = controller
		} else if (LAYER_PICKER_MODAL == segue.identifier) {
			let controller = segue.destinationViewController as LayerPickerNavigationController
			controller.layerPickerDelegate = self
			
			controller.layers = scene!.layers
			controller.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
		}
	}
	
	private func render()
	{
		agent.render(scene!, onto:canvas, highlighting:focusedLayerIndex)
	}
	
	func toolbarEvent(changed: Bool, caption: String) {
		scene?.caption = caption
		render()
	}
	
	func toolbarEvent(changed: Bool, rotation: Int) {
		focusedLayer?.rotation = rotation
		render()
	}
	
	func toolbarEvent(changed: Bool, scale: Float) {
		focusedLayer?.scale = scale
		render()
	}
	
	func toolbarEvent(changed: Bool, opacity: Float) {
		focusedLayer?.opacity = opacity
		render()
	}
	
	func toolbarEvent(changed: Bool, top: Int) {
		focusedLayer?.top = top
		render()
	}
	
	func toolbarEvent(changed: Bool, left: Int) {
		focusedLayer?.left = left
		render()
	}

	
	
	
	
	
	
	
	func toolbarEvent(clickedButton: Bool, layerPicker: Bool) {
		self.performSegueWithIdentifier(LAYER_PICKER_MODAL, sender: self)
	}
	
	func layerPicker(pickerController: LayerPickerViewController, didSelectLayer index: Int) {
		self.focusedLayerIndex = index
		pickerController.dismissViewControllerAnimated(true, completion: nil)
	}

	func layerPicker(pickerController: LayerPickerViewController, didMoveIndexFrom oldIndex: Int, to newIndex: Int) {
		println("triggered layer-moved event")
	}
	
	func layerPicker(pickerController: LayerPickerViewController, didCreateLayer newLayer: Layer) {
		let scene = self.scene!
		scene.layers.append(newLayer)
		
		self.focusedLayerIndex = scene.layers.count - 1
		
		render()
		pickerController.dismissViewControllerAnimated(true, completion: nil)
	}
	
	
	
	
	
	
	
	func initialCaption() -> String {
		return scene?.caption ?? ""
	}
	
	func initialRotation() -> Int {
		return focusedLayer?.rotation ?? 0
	}
	
	func initialScale() -> Float {
		return focusedLayer?.scale ?? 0
	}
	
	func initialOpacity() -> Float {
		return focusedLayer?.opacity ?? 1.0
	}
	
	func initialTop() -> Int {
		return focusedLayer?.top ?? 0
	}
	
	func initialLeft() -> Int {
		return focusedLayer?.left ?? 0
	}
}
