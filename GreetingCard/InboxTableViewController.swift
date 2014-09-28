//
//  InboxTableViewController.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class InboxTableViewController: UITableViewController, UITableViewDataSource
{
	let SEGUE_VIEW_CARD = "view_card"
	
	var cards: [Card] = DataUtility.GenerateCards()
	
	///
	/// Post-initialization hook
	///
	override func viewDidLoad()
	{
		super.viewDidLoad()
	}
	
	///
	/// All segues pass through here
	///
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		let index = self.tableView.indexPathForCell(sender as UITableViewCell)!.item
		
		if (SEGUE_VIEW_CARD == segue.identifier) {
			let controller = segue.destinationViewController as CardViewController
			controller.card = self.cards[index]
		}
	}
	
	///
	/// Returns the total number of table rows
	///
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return cards.count
	}

	///
	/// Handles drawing cells
	///
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier("card", forIndexPath:indexPath) as UITableViewCell
		
		let currentCard = cards[indexPath.item]
		
		cell.textLabel?.text = currentCard.title;
		cell.detailTextLabel?.text = "1 / \(currentCard.scenes.count)"
		
		return cell
	}
}
