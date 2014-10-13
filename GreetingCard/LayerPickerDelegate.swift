//
//  ILayerPickerDelegate.swift
//  GreetingCard
//
//  Created by David Bazile on 10/5/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

protocol LayerPickerDelegate
{
	func layerPicker(pickerController:LayerPickerViewController, didCreateLayer newLayer:Layer)
	func layerPicker(pickerController:LayerPickerViewController, didMoveIndexFrom oldIndex:Int, to newIndex:Int)
	func layerPicker(pickerController:LayerPickerViewController, didSelectLayer index:Int)
}