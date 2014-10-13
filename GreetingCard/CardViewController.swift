//
//  CardViewController.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class CardViewController : UIViewController,
						   UIPageViewControllerDataSource
{
	private let SCENE_VIEW_CONTROLLER = "SceneViewController"
	private let VERTICAL_OFFSET : CGFloat = 0
	private var pageViewController : UIPageViewController?
	
	var card : Card?
	
	///
	/// Configures the page view controller
	///
    override func viewDidLoad()
	{
        super.viewDidLoad()
		self.initializePageViewController()
    }
	
	///
	/// Hides the nav bar when viewing a card
	///
	override func viewWillAppear(animated: Bool)
	{
		self.navigationController?.navigationBarHidden = true
		self.navigationController?.hidesBarsOnTap = true
		self.title = card?.title
	}
	
	///
	/// Restores the nav bar when leaving
	///
	override func viewWillDisappear(animated: Bool)
	{
		self.navigationController?.navigationBarHidden = false
		self.navigationController?.hidesBarsOnTap = false
	}
	
	
	// PAGE VIEW CONTROLLER DATASOURCE /////////////////////////////////////////
	
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
	
	
	// HELPER METHODS //////////////////////////////////////////////////////////
	
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
