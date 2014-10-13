//
//  EditSceneToolbarDelegate.swift
//  GreetingCard
//
//  Created by David Bazile on 10/4/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

protocol EditSceneToolbarDelegate
{
	func toolbar(toolbar:UIViewController, didChangeCaption caption:String)
	func toolbar(toolbar:UIViewController, didChangeLeft left:Int)
	func toolbar(toolbar:UIViewController, didChangeOpacity opacity:Float)
	func toolbar(toolbar:UIViewController, didChangeRotation rotation:Int)
	func toolbar(toolbar:UIViewController, didChangeScale scale:Float)
	func toolbar(toolbar:UIViewController, didChangeTop top:Int)
	func toolbar(toolbar:UIViewController, didClickLayerDeleteButton: Bool)
	func toolbar(toolbar:UIViewController, didClickLayerDownButton: Bool)
	func toolbar(toolbar:UIViewController, didClickLayerPickerButton: Bool)
	func toolbar(toolbar:UIViewController, didClickLayerUpButton: Bool)
	func toolbar(toolbar:UIViewController, initialCaptionValue defaultValue:String) -> String
	func toolbar(toolbar:UIViewController, initialLeftValue defaultValue:Int) -> Int
	func toolbar(toolbar:UIViewController, initialOpacityValue defaultValue:Float) -> Float
	func toolbar(toolbar:UIViewController, initialRotationValue defaultValue:Int) -> Int
	func toolbar(toolbar:UIViewController, initialScaleValue defaultValue:Float) -> Float
	func toolbar(toolbar:UIViewController, initialTopValue defaultValue:Int) -> Int
}