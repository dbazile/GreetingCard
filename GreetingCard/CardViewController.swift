//
//  CardViewController.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

class CardViewController: UIViewController, UIPageViewControllerDataSource {
	
	let VERTICAL_OFFSET : CGFloat = 0
	var pageViewController : UIPageViewController?
	var card : Card?
	
    override func viewDidLoad()
	{
        super.viewDidLoad()
		self.initializePageViewController()
    }
	
	override func viewWillAppear(animated: Bool) {
		self.navigationController?.navigationBarHidden = true
		self.navigationController?.hidesBarsOnTap = true
		self.title = card?.title
	}
	
	override func viewWillDisappear(animated: Bool) {
		self.navigationController?.navigationBarHidden = false
		self.navigationController?.hidesBarsOnTap = false
	}
	
	func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
		return card!.scenes.count
	}
	
	func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
		return 0
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
		let index = sceneIndex(viewController) - 1
		return sceneController(index)
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
		let index = sceneIndex(viewController) + 1
		return sceneController(index)
	}
	
	private func sceneIndex(controller: UIViewController) -> Int
	{
		return (controller as SceneViewController).index
	}
	
	private func sceneController(index: Int) -> SceneViewController?
	{
		let scenes = card!.scenes
		
		if (index >= 0 && index < scenes.count) {
			let scene = scenes[index]
			
			let controller = self.storyboard!.instantiateViewControllerWithIdentifier("SceneViewController") as SceneViewController
			controller.view.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
			controller.scene = scene
			controller.index = index
			return controller
		} else {
			return nil
		}
	}
	
	private func initializePageViewController() {
		self.pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
		let controller = self.pageViewController!
		
		let controllers = [sceneController(0)!]
		controller.setViewControllers(controllers, direction: .Forward, animated: false, completion: {done in})
		
		controller.dataSource = self
		
		self.addChildViewController(controller)
		self.view.addSubview(controller.view)
		
		controller.view.frame = CGRectMake(0, VERTICAL_OFFSET, self.view.bounds.width, self.view.bounds.height-VERTICAL_OFFSET)
		
		controller.didMoveToParentViewController(self)
		
		self.pageViewController = controller
		self.view.gestureRecognizers = controller.gestureRecognizers
		
	}
}
