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
	private let EDIT_CARD_SEGUE  = "EditCardSegue"
	private let TAG_TITLE_LABEL  = 1
	private let TAG_DETAIL_LABEL = 2
	private let TAG_CANVAS       = 3
	
	private let agent = RenderingAgent()
	
	var cards: [Card] {
		return DataUtility.AllCards
	}
	
	///
	/// Reloads the cells when the view regains focus
	///
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

	///
	/// Intercept segue to configure destination controllers
	///
	override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?)
	{
		let index = self.tableView.indexPathForCell(sender as UITableViewCell)!.item

		switch(segue.identifier) {

		case VIEW_CARD_SEGUE:
			let controller = segue.destinationViewController as CardViewController
			controller.card = self.cards[index]
			break

		case EDIT_CARD_SEGUE:
			let controller = segue.destinationViewController as EditCardViewController
			controller.card = self.cards[index]
			break

		default:
			break
		}
	}


	// MARK: TABLEVIEW DATASOURCE //////////////////////////////////////////////

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

		updateCell(cell, card:card)
		
		return cell
	}


	// MARK: HELPER METHODS ////////////////////////////////////////////////////

	///
	/// Updates a cell with the card data
	///
	private func updateCell(cell:UITableViewCell, card:Card)
	{
		let title = cell.viewWithTag(TAG_TITLE_LABEL) as UILabel
		let details = cell.viewWithTag(TAG_DETAIL_LABEL) as UILabel
		let canvas = cell.viewWithTag(TAG_CANVAS)!
	
		// Set the text
		title.text = card.title
		details.text = "(1 / \(card.scenes.count))"

		// Render the preview with a vertical offset
		let H = CGFloat(500)
		canvas.frame = CGRectMake(0, cell.frame.height - H/1.5, cell.frame.width, H)
		agent.render(card.scenes.first!, onto:canvas)
	}
}
