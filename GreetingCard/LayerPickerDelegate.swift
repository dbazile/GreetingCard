//
//  ILayerPickerDelegate.swift
//  GreetingCard
//
//  Created by David Bazile on 10/5/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

protocol LayerPickerDelegate
{
	func layerPicker(pickerController: LayerPickerViewController, didSelectLayer: Int)
	func layerPicker(pickerController: LayerPickerViewController, didMoveIndex: Int, toIndex: Int)
	func layerPicker(pickerController: LayerPickerViewController, didRequestNewLayer: Bool)
}