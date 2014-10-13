//
//  InboxTableViewController.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class InboxTableViewController: UITableViewController,
                                UITableViewDataSource
{
	private let CARD_CELL        = "CardCell"
	private let VIEW_CARD_SEGUE  = "ViewCardSegue"
	private let TAG_TITLE_LABEL  = 1001
	private let TAG_DETAIL_LABEL = 1002
	
	var cards: [Card] = DataUtility.LoadCards()
	
	///
	/// Post-initialization hook
	///
	override func viewDidLoad()
	{
		super.viewDidLoad()
	}
	
	///
	/// Intercept segue to configure destination controllers
	///
	override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?)
	{
		let index = self.tableView.indexPathForCell(sender as UITableViewCell)!.item
		
		if (VIEW_CARD_SEGUE == segue.identifier) {
			let controller = segue.destinationViewController as CardViewController
			controller.card = self.cards[index]
		}
	}
	
	
	// TABLEVIEW DATASOURCE ////////////////////////////////////////////////////
	
	///
	/// Returns the total number of table rows
	///
	override func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
	{
		return cards.count
	}

	///
	/// Handles drawing cells
	///
	override func tableView(tableView:UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell
	{
		let cell = tableView.dequeueReusableCellWithIdentifier(CARD_CELL, forIndexPath:indexPath) as UITableViewCell
		let card = cards[indexPath.item]
		
		self.updateCell(cell, card:card)
		
		return cell
	}
	
	
	// HELPER METHODS //////////////////////////////////////////////////////////
	
	///
	/// Updates a cell with the card data
	///
	private func updateCell(cell:UITableViewCell, card:Card)
	{
		let title = cell.viewWithTag(TAG_TITLE_LABEL) as UILabel
		let details = cell.viewWithTag(TAG_DETAIL_LABEL) as UILabel
		
		title.text = card.title
		details.text = "(1 / \(card.scenes.count))"
	}
}
