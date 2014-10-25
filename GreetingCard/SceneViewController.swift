//
//  SceneViewController.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class SceneViewController : UIViewController
{
	private let agent = RenderingAgent()

	var scene : Scene?
	var index : Int = -1

	///
	/// One-time controller setup
	///
    override func viewDidLoad()
	{
        super.viewDidLoad()
		
		// Clear the greenscreen on the canvas
		canvas.backgroundColor = UIColor.clearColor()
		agent.normalize(canvas)
    }

	///
	/// Renders the scene whenever the view becomes active
	///
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		agent.render(scene!, onto: canvas)
		caption.text = scene?.caption
	}


	// MARK: INTERFACE BUILDER /////////////////////////////////////////////////

	@IBOutlet weak var canvas : UIView!
	@IBOutlet weak var caption : UILabel!
}
