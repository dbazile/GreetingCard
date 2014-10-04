//
//  EditSceneViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/3/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class EditSceneViewController: UIViewController {
	var scene : Scene?
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(animated: Bool) {
		let label = UILabel(frame: view.frame)
		label.text = scene!.caption
		label.numberOfLines = 5

		render(scene!)
	}
	
	private func render(scene : Scene)
	{
		
	}

}
