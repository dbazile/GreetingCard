//
//  EditSceneViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/3/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class EditSceneViewController: UIViewController, EditSceneToolbarDelegate {
	let EDIT_SCENE_TOOLBAR = "EditSceneToolbar"
	let agent = RenderingAgent()
	var toolbarController : EditSceneToolbarViewController?
	var scene : Scene?
	var focusedLayer : Layer?
	var focusedLayerIndex = 0
	
	@IBOutlet weak var canvas: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		agent.normalize(canvas)
		focusedLayerDidChange(focusedLayerIndex)
//		navigationController?.hidesBarsOnTap = true
//		navigationController?.navigationBarHidden = true
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
		}
	}
	
	func focusedLayerDidChange(index: Int)
	{
		print("[focusedLayerDidChange \(index)] ")
		if (index < scene?.layers.count) {
			focusedLayerIndex = index
			focusedLayer = scene!.layers[index]
			toolbarController!.layerIndex = index
		} else {
			print("WARNING - index out of bounds")
		}
		println()
	}

	private func render()
	{
		agent.render(scene!, withHighlightIndex: focusedLayerIndex, onCanvas: canvas)
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
	
	
	
	let LAYER_PICKER = "LayerPickerViewController"
	
	func toolbarEvent(clickedButton: Bool, layerPicker: Bool) {
		let controller = storyboard?.instantiateViewControllerWithIdentifier(LAYER_PICKER) as LayerPickerViewController
		controller.layers = scene!.layers
		controller.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
		self.presentViewController(controller, animated: true, completion: nil)
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
