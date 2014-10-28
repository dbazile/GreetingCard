//
//  CardViewController.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit
import MessageUI

class CardViewController : UIViewController,
						   UIPageViewControllerDataSource
{
	private let ACTION_DELETE = 0
	private let ACTION_SEND = 2
	private let ACTION_EDIT = 3
	private let EDIT_SEGUE = "EditSegue"
	private let SHARE_SEGUE = "ShareSegue"
	private let SCENE_VIEW_CONTROLLER = "SceneViewController"
	private let DELETE_CARD = "Delete this Card"
	private let SHARE_CARD = "Share this Card"
	private let EDIT_CARD = "Edit this Card"
	private let CANCEL = "Cancel"
	private var pageViewController : UIPageViewController?

	var card : Card?

	///
	/// One-time controller setup
	///
    override func viewDidLoad()
	{
        super.viewDidLoad()
		
		Decorator.applyBackButton(on:self)
		Decorator.applyMenuButton(on:self, onClickInvoke:"didClickMenuButton")
		
		initializePageViewController()
    }
	
	///
	/// Hides the nav bar when viewing a card
	///
	override func viewWillAppear(animated: Bool)
	{
		self.navigationController?.navigationBarHidden = true
		self.navigationController?.hidesBarsOnTap = true
		self.title = card?.title
		
		// Make card as read
		card?.isNew = false
	}
	
	///
	/// Restores the nav bar when leaving
	///
	override func viewWillDisappear(animated: Bool)
	{
		self.navigationController?.navigationBarHidden = false
		self.navigationController?.hidesBarsOnTap = false
	}
	
	///
	/// Executes when the user clicks the menu button in the navbar
	///
	func didClickMenuButton()
	{
		// Create the action sheet
		let actionSheet = UIAlertController(title:nil, message:nil, preferredStyle: .ActionSheet)
		actionSheet.addAction(UIAlertAction(title:DELETE_CARD, style:.Destructive, handler:didSelectDeleteAction))
		actionSheet.addAction(UIAlertAction(title:SHARE_CARD, style:.Default, handler:didSelectSendAction))
		actionSheet.addAction(UIAlertAction(title:EDIT_CARD, style:.Default, handler:didSelectEditAction))
		actionSheet.addAction(UIAlertAction(title:CANCEL, style:.Cancel, handler:nil))
		
		// Display
		self.presentViewController(actionSheet, animated:true, completion:nil)
	}

	///
	/// Intercepts the segue to pass data to the next controller
	///
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if (EDIT_SEGUE == segue.identifier) {
			let controller = segue.destinationViewController as EditCardViewController
			controller.card = card!
		}
	}

	
	// MARK: - INTERFACEBUILDER CONNECTIONS ///////////////////////////////////////////
	
	@IBOutlet weak var placeholderForNoScenes: UIView!
	
	
	// MARK: - ACTIONCONTROLLER DELEGATE //////////////////////////////////////////////
	
	///
	/// Executes when the user selects 'Delete Card' from the action sheet
	///
	private func didSelectDeleteAction(sender:UIAlertAction!)
	{
		DataUtility.Delete(card!)
		
		// Return to the inbox
		navigationController?.popViewControllerAnimated(true)
		
		// Queue the delete notification
		let alert = UIAlertController(title:"Card deleted", message:"You deleted the card titled \"\(card!.title)\".", preferredStyle:.Alert)
		alert.addAction(UIAlertAction(title:"OK", style:.Default, handler:nil))
		navigationController!.presentViewController(alert, animated:false, completion:nil)
	}
	
	///
	/// Executes when the user selects 'Edit Card' from the action sheet
	///
	private func didSelectEditAction(sender:UIAlertAction!)
	{
		performSegueWithIdentifier(EDIT_SEGUE, sender:nil)
	}
	
	///
	/// Executes when the user selects 'Send Card' from the action sheet
	///
	private func didSelectSendAction(sender:UIAlertAction!)
	{
		//
		// SHARE OPERATION
		//
		var encodedImage = UIImagePNGRepresentation(UIImage(named: "EmbeddedIcon")).base64EncodedStringWithOptions(nil)
		var encodedCard = DataUtility.Export(card!)
		var html = "<a href=\"greetingcard://import/\(encodedCard)\"><img src=\"data:image/png;base64,\(encodedImage)\"/></a>"
		var mf = MFMailComposeViewController()
		mf.setSubject("GreetingCard: ")
		mf.setMessageBody(html, isHTML: true)
		self.presentViewController(mf, animated: false, completion: nil)
		//
		// SHARE OPERATION
		//
	}
	

	// MARK: - PAGE VIEW CONTROLLER DATASOURCE ///////////////////////////////////

	///
	/// Sets the total number of pages
	///
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
	{
		return card!.scenes.count
	}

	///
	/// Sets the initial page index
	///
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
	{
		return 0
	}

	///
	/// Returns the controller for the previous page
	///
	func pageViewController(pageViewController:UIPageViewController, viewControllerBeforeViewController viewController:UIViewController) -> UIViewController? {
		let index = indexOf(viewController) - 1
		return sceneController(index)
	}

	///
	/// Returns the controller for the upcoming page
	///
	func pageViewController(pageViewController:UIPageViewController, viewControllerAfterViewController viewController:UIViewController) -> UIViewController? {
		let index = indexOf(viewController) + 1
		return sceneController(index)
	}


	// MARK: - HELPER METHODS ////////////////////////////////////////////////////

	///
	/// Returns the index of a given page
	///
	private func indexOf(controller: UIViewController) -> Int
	{
		return (controller as SceneViewController).index
	}

	///
	/// Initializes the PageViewController
	///
	private func initializePageViewController() {

		if let firstPage = sceneController(0) {
			// Get rid of the "No Scenes" placeholder
			placeholderForNoScenes.removeFromSuperview()
			
			// Create the PageViewController
			let controller = UIPageViewController(transitionStyle:.Scroll, navigationOrientation:.Horizontal, options:nil)
			
			controller.setViewControllers([firstPage], direction:.Forward, animated:false, completion:{done in})
			controller.dataSource = self
			
			// Wire the PageViewController to this controller
			self.addChildViewController(controller)
			self.view.addSubview(controller.view)
			
			controller.view.frame = self.view.bounds
			
			// Trigger the PageViewController events
			controller.didMoveToParentViewController(self)
			
			self.pageViewController = controller
			self.view.gestureRecognizers = controller.gestureRecognizers
		}
	}

	///
	/// Returns a controller for a given index
	///
	private func sceneController(index: Int) -> SceneViewController?
	{
		let scenes = card!.scenes

		if (index >= 0 && index < scenes.count) {
			let scene = scenes[index]

			let controller = self.storyboard!.instantiateViewControllerWithIdentifier(SCENE_VIEW_CONTROLLER) as SceneViewController
			controller.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
			controller.scene = scene
			controller.index = index
			return controller
		} else {
			return nil
		}
	}
}
