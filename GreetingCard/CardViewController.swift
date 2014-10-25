//
//  CardViewController.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class CardViewController : UIViewController,
						   UIPageViewControllerDataSource,
	                       UIActionSheetDelegate
{
	private let ACTION_DELETE = 0
	private let ACTION_SEND = 2
	private let ACTION_EDIT = 3
	private let EDIT_SEGUE = "EditSegue"
	private let SHARE_SEGUE = "ShareSegue"
	private let SCENE_VIEW_CONTROLLER = "SceneViewController"
	private let VERTICAL_OFFSET : CGFloat = 0
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
		let sheet = UIActionSheet(title:nil,
			                   delegate:self,
			          cancelButtonTitle:"Cancel",
			     destructiveButtonTitle:"Delete this Card",
			          otherButtonTitles:"Send this Card",
			                            "Edit Card")
		
		sheet.showFromBarButtonItem(navigationItem.rightBarButtonItem, animated: true)
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

	
	// MARK: ACTIONSHEET DELEGATE //////////////////////////////////////////////
	
	///
	/// Executes when the user selects something from the action sheet
	///
	func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
		
		switch(buttonIndex) {
		case ACTION_DELETE:
			didSelectDeleteAction()
			break
			
		case ACTION_EDIT:
			didSelectEditAction()
			break
			
		case ACTION_SEND:
			didSelectSendAction()
			break
			
		default:
			break
		}
	}
	
	///
	/// Executes when the user selects 'Delete Card' from the action sheet
	///
	private func didSelectDeleteAction()
	{
		DataUtility.Delete(card!)
		let alert = UIAlertView(title: "Card Deleted", message: "You deleted the card titled \"\(card!.title)\".", delegate: nil, cancelButtonTitle:"OK")
		alert.show()
		navigationController?.popViewControllerAnimated(true)
	}
	
	///
	/// Executes when the user selects 'Edit Card' from the action sheet
	///
	private func didSelectEditAction()
	{
		performSegueWithIdentifier(EDIT_SEGUE, sender:nil)
	}
	
	///
	/// Executes when the user selects 'Send Card' from the action sheet
	///
	private func didSelectSendAction()
	{
		let alert = UIAlertView(title: "EMAIL", message: "EMAIL", delegate: nil, cancelButtonTitle: "SEND")
		alert.show()
	}
	

	// MARK: PAGE VIEW CONTROLLER DATASOURCE ///////////////////////////////////

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


	// MARK: HELPER METHODS ////////////////////////////////////////////////////

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

		// Create the PageViewController
		let controller = UIPageViewController(transitionStyle:.Scroll, navigationOrientation:.Horizontal, options:nil)

		// Add pages
		let firstPage = sceneController(0)!
		controller.setViewControllers([firstPage], direction:.Forward, animated:false, completion:{done in})
		controller.dataSource = self

		// Wire the PageViewController to this controller
		self.addChildViewController(controller)
		self.view.addSubview(controller.view)

		controller.view.frame = CGRectMake(0, VERTICAL_OFFSET, self.view.bounds.width, self.view.bounds.height-VERTICAL_OFFSET)

		// Trigger the PageViewController events
		controller.didMoveToParentViewController(self)

		self.pageViewController = controller
		self.view.gestureRecognizers = controller.gestureRecognizers
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
