//
//  InboxTableViewController.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import MessageUI
import UIKit

class InboxTableViewController: UITableViewController,
                                UITableViewDataSource,
	                            UIGestureRecognizerDelegate
{
	private let CARD_CELL        = "CardCell"
	private let VIEW_CARD_SEGUE  = "ViewCardSegue"
	private let EDIT_CARD_SEGUE  = "EditCardSegue"
	private let TAG_TITLE_LABEL  = 1
	private let TAG_DETAIL_LABEL = 2
	private let TAG_CANVAS       = 3
	
	private let agent = RenderingAgent()
	private var listeningForChangeEvents = false
	
	var cards: ArrayList<Card> {
		return DataUtility.AllCards
	}
	
	///
	/// One-time controller setup
	///
	override func viewDidLoad() {
		super.viewDidLoad()
		
		Decorator.applyLogo(on:self)
		Decorator.applyCreateButton(on:self, onClickInvoke:"didClickCreateButton")
		Decorator.applyBackButton(on:self)
	}
	
	///
	/// Reloads the cells when the view regains focus
	///
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		Decorator.usingViewContext(navigationController)

		tableView.reloadData()
		
		subscribeToCardchangeEvents()
	}
	
	///
	/// Unlinks the notification observer
	///
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		unsubscribeFromCardchangeEvents()
	}
	
	///
	/// Intercept segue to configure destination controllers
	///
	override func prepareForSegue(segue:UIStoryboardSegue, sender:AnyObject?)
	{

		// Determine which card Get the card
		var card: Card?
		
		// TODO: Not crazy about this implementation
		/*
		 * Use the sender to determine where the segue is going and what it needs to
		 * take with it:
		 *
		 *     - If not coming from a cell, it's a new card that needs to go
		 *       to the 'Edit Card' controller.
		 *
		 *     - If coming from a cell, it's an existing card that either needs
		 *       to go to the 'View Card' or the 'Edit Card' controller.
		 */
		if let cell = sender as? UITableViewCell {
			let indexPath = tableView.indexPathForCell(cell)!
			card = cards[indexPath.item]
		} else {
			// Segue originating from a navbar action
			card = DataUtility.NewCard()
		}
		
		switch(segue.identifier!) {
		case EDIT_CARD_SEGUE:
			let controller = segue.destinationViewController as EditCardViewController
			
			controller.card = card
			break
			
		case VIEW_CARD_SEGUE:
			let controller = segue.destinationViewController as CardViewController
			controller.card = card
			break
			
		default:
			break
		}
		
	}
	
	///
	/// Executes when the user clicks the 'Create Card' button on the navbar
	///
	func didClickCreateButton()
	{
		self.performSegueWithIdentifier(EDIT_CARD_SEGUE, sender:nil)
	}
	
	///
	/// Executes when the user clicks on the `Delete` button after swiping a table cell
	///
	private func didClickDeleteAction(action: UITableViewRowAction!, indexPath: NSIndexPath!)
	{
		cards.remove(indexPath.item)
		tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
		tableView(tableView, commitEditingStyle: .Delete, forRowAtIndexPath: indexPath)
	}
	
	///
	/// Executes when the user clicks on the `Share` button after swiping a table cell
	///
	private func didClickShareAction(action: UITableViewRowAction!, indexPath: NSIndexPath!)
	{
		//
		// SHARE OPERATION
		//
		var encodedImage = UIImagePNGRepresentation(UIImage(named: "EmbeddedIcon")).base64EncodedStringWithOptions(nil)
		var encodedCard = DataUtility.Export(cards[indexPath.item])
		var html = "<a href=\"greetingcard://import/\(encodedCard)\"><img src=\"data:image/png;base64,\(encodedImage)\"/></a>"
		var mf = MFMailComposeViewController()
		mf.setSubject("GreetingCard: ")
		mf.setMessageBody(html, isHTML: true)
		print(html)
		self.presentViewController(mf, animated: false, completion: nil)
		//
		// SHARE OPERATION
		//
	}
	

	// MARK: - TABLEVIEW DATASOURCE //////////////////////////////////////////////

	///
	/// Performs the final action on a table row edit (doesn't get automatically called if you've got
	/// custom edit actions defined...)
	///
	override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
		tableView.editing = false
	}
	
	///
	/// Sets the availble options when the row is swiped
	///
	override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
		let deleteAction = UITableViewRowAction(style:.Default, title:"Delete", handler:didClickDeleteAction)
		let shareAction = UITableViewRowAction(style:.Normal, title:"Share", handler:didClickShareAction)
		return [deleteAction, shareAction]
	}
	
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


	// MARK: - HELPER METHODS ////////////////////////////////////////////////////

	///
	/// Callback to reloads the table data when the cardstore changes
	///
	func refreshTable()
	{
		tableView.reloadData()
	}
	
	///
	/// Enables listening for cardstore change notifications
	///
	private func subscribeToCardchangeEvents()
	{
		if (false == listeningForChangeEvents) {
			NSNotificationCenter.defaultCenter()
				.addObserver(self,
					selector:"refreshTable",
					name:DataDidSaveCardstore,
					object:nil)
			
			listeningForChangeEvents = true
		}
	}
	
	///
	/// Disables listening for cardstore change notifications
	///
	private func unsubscribeFromCardchangeEvents()
	{
		if (true == listeningForChangeEvents) {
			NSNotificationCenter.defaultCenter()
				.removeObserver(self)
			
			listeningForChangeEvents = false
		}
	}
	
	///
	/// Updates a cell with the card data
	///
	private func updateCell(cell:UITableViewCell, card:Card)
	{
		let title = cell.viewWithTag(TAG_TITLE_LABEL) as UILabel
		let details = cell.viewWithTag(TAG_DETAIL_LABEL) as UILabel
		let canvas = cell.viewWithTag(TAG_CANVAS)!
	
		if (card.isNew) {
			
			//
			// Hide the preview using the "Unread" image
			//
			
			agent.purge(canvas)
			
			// Set the text
			title.text = card.title
			title.alpha = 0.2
			details.text = "Unread"
			
			let envelope = UIImageView(image: UIImage(named: "Unread"))
			envelope.frame = cell.bounds
			
			canvas.addSubview(envelope)
			canvas.alpha = 1
		} else {
			
			//
			// Render the Preview
			//
			
			// Set the text
			title.text = card.title
			title.alpha = 1.0
			details.text = ""
			
			if let firstScene = card.scenes.first {
				agent.render(firstScene, onto:canvas, offset:CGPoint(x:0, y:-200))
				canvas.alpha = 0.1
			} else {
				details.text = "(No Scenes)"
			}
		}
	}
}
