//
//  EditSceneToolbarDelegate.swift
//  GreetingCard
//
//  Created by David Bazile on 10/4/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

protocol EditSceneToolbarDelegate
{
	
	/// Handler for changes to the 'caption' textfield
	func toolbarEvent(changed: Bool, caption: String)
	
	/// Handler for changes to the 'opacity' slider
	func toolbarEvent(changed: Bool, opacity: Float)
	
	/// Handler for changes to the 'rotation' slider
	func toolbarEvent(changed: Bool, rotation: Int)
	
	/// Handler for changes to the 'scale' slider
	func toolbarEvent(changed: Bool, scale: Float)
	
	/// Handler for changes to the 'top' slider
	func toolbarEvent(changed: Bool, top: Int)
	
	/// Handler for changes to the 'left' slider
	func toolbarEvent(changed: Bool, left: Int)
	
	
	
	
	
	
	func toolbarEvent(clickedButton: Bool, layerPicker: Bool)
	
	
	
	
	

	//
	// Initial values for the sliders
	//
	
	/// Returns the initial value for the scene's 'caption' property
	func initialCaption() -> String
	
	/// Returns the initial value for the 'rotation' property
	func initialRotation() -> Int
	
	/// Returns the initial value for the 'opacity' property
	func initialOpacity() -> Float
	
	/// Returns the initial value for the 'scale' property
	func initialScale() -> Float
	
	/// Returns the initial value for the 'top' property
	func initialTop() -> Int
	
	/// Returns the initial value for the 'left' property
	func initialLeft() -> Int
}