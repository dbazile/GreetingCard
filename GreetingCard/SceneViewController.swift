//
//  SceneViewController.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class SceneViewController: UIViewController {
	@IBOutlet weak var caption: UILabel!
	var scene: Scene = Scene(layers: [], caption: "Unloaded Scene")
	var index: Int = -1
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		caption.text = scene.caption
	}
	
}
