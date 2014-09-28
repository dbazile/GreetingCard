//
//  DataViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 9/28/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

	@IBOutlet weak var dataLabel: UILabel!
	var dataObject: AnyObject?


	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if let obj: AnyObject = dataObject {
		    self.dataLabel!.text = obj.description
		} else {
		    self.dataLabel!.text = ""
		}
	}


}

