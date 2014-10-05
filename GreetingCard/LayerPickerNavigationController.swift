//
//  LayerPickerNavigationController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/5/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class LayerPickerNavigationController: UINavigationController {

	var pickerDelegate : LayerPickerDelegate?
	var layers : [Layer]?
	
	override func viewDidLoad() {
		let controller = self.topViewController as LayerPickerViewController
		controller.layers = layers!
		controller.delegate = pickerDelegate!
	}
}
