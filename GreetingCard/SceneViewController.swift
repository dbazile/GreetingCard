//
//  SceneViewController.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class SceneViewController: UIViewController
{
	@IBOutlet weak var canvas: UIView!
	@IBOutlet weak var caption: UILabel!
	
	let agent = RenderingAgent()
	
	var scene: Scene?
	var index: Int = -1
	
    override func viewDidLoad() {
        super.viewDidLoad()
		agent.normalize(canvas)
    }
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		agent.render(scene!, onCanvas: canvas)
		caption.text = scene?.caption
	}
}
