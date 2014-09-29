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
	let IDENTIFIER_CARD_CELL = "CardCell"
	let IDENTIFIER_VIEWCARD_SEGUE = "ViewCard"
	let TAG_TITLE_LABEL = 1001
	let TAG_DETAIL_LABEL = 1002
	
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
		
		if (IDENTIFIER_VIEWCARD_SEGUE == segue.identifier) {
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
		let cell = tableView.dequeueReusableCellWithIdentifier(IDENTIFIER_CARD_CELL, forIndexPath:indexPath) as UITableViewCell
		let card = cards[indexPath.item]
		
		self.updateCell(cell, card:card)
		
		return cell
	}
	
	private func updateCell(cell: UITableViewCell, card: Card)
	{
		let title = cell.viewWithTag(TAG_TITLE_LABEL) as UILabel
		let details = cell.viewWithTag(TAG_DETAIL_LABEL) as UILabel
		
		title.text = card.title
		details.text = "(1 / \(card.scenes.count))"
	}
}
