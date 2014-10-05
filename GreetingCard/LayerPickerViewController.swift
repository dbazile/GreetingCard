//
//  LayerPickerViewController.swift
//  GreetingCard
//
//  Created by David Bazile on 10/5/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class LayerPickerViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
	let LAYER_CELL = "LayerCell"
	
	var layers : [Layer]?
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return layers!.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier(LAYER_CELL, forIndexPath: indexPath) as UITableViewCell
		
		let i = indexPath.item
		
		cell.textLabel?.text = "Layer \(i)"
		
		return cell
	}
}
