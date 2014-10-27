//
//  Decorator.swift
//  GreetingCard
//
//  Created by David Bazile on 10/21/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import Foundation
import UIKit

private let COLOR_ORANGE  = UIColor(hue: 23/360.0, saturation:0.45, brightness:1.00, alpha:1)
private let COLOR_PURPLE  = UIColor(hue:264/360.0, saturation:0.30, brightness:0.58, alpha:1)
private let COLOR_RED     = UIColor(hue:  2/360.0, saturation:0.67, brightness:1.00, alpha:1)
private let COLOR_BLUE    = UIColor(hue:214/360.0, saturation:0.73, brightness:0.69, alpha:1)
private let COLOR_WHITE   = UIColor.whiteColor()
private let COLOR_BLACK   = UIColor.blackColor()
private let SHADOWCOLOR   = UIColor(white:0, alpha:0.5)
private let NAVBAR_VIEW_BACKCOLOR = COLOR_PURPLE
private let NAVBAR_VIEW_FORECOLOR = COLOR_WHITE
private let NAVBAR_VIEW_TINTCOLOR = COLOR_WHITE
private let NAVBAR_VIEW_STATUSSTYLE = UIStatusBarStyle.LightContent
private let NAVBAR_EDIT_BACKCOLOR = COLOR_BLUE
private let NAVBAR_EDIT_FORECOLOR = COLOR_WHITE
private let NAVBAR_EDIT_TINTCOLOR = COLOR_WHITE
private let NAVBAR_EDIT_STATUSSTYLE = UIStatusBarStyle.LightContent
private let VIEW_CONTEXT = 0
private let EDIT_CONTEXT = 1

private var _currentContext = -1

class Decorator
{
	///
	/// Applies the back button styling on a view controller's navbar
	///
	class func applyBackButton(on controller:UIViewController)
	{
		return setLeftButton(controller, imageName:"ButtonBack")
	}
	
	///
	/// Applies the back button styling with custom operation on a view controller's navbar
	///
	class func applyBackButton(on controller:UIViewController, onClickInvoke selector:Selector)
	{
		// Custom button should supplant the normal back button
		controller.navigationItem.leftItemsSupplementBackButton = false
		
		// Add our custom button
		controller.navigationItem.leftBarButtonItem = UIBarButtonItem(
			 image:image("ButtonBack"),
			 style:.Plain,
			target:controller,
			action:selector)
	}
	
	///
	/// Adds and styles a create button on a view controller's navbar
	///
	class func applyCreateButton(on controller:UIViewController, onClickInvoke selector:Selector)
	{
		return setRightButton(controller, imageName:"ButtonCreate", selector:selector)
	}
	
	///
	/// Adds the custom app logo on a view controller's navbar's navbar
	///
	class func applyLogo(on controller: UIViewController)
	{
		let logo = UIImage(named: "LogoNavbar")
		controller.navigationItem.titleView = UIImageView(image:logo)
	}
	
	///
	/// Adds and styles a menu button on a view controller's navbar
	///
	class func applyMenuButton(on controller:UIViewController, onClickInvoke selector:Selector)
	{
		return setRightButton(controller, imageName:"ButtonMenu", selector:selector)
	}
	
	///
	/// Adds and styles a save button on a view controller's navbar
	///
	class func applySaveButton(on controller:UIViewController, onClickInvoke selector:Selector)
	{
		return setRightButton(controller, imageName:"ButtonSave", selector:selector)
	}
	
	///
	/// Adds the "done editing table" button to the navbar
	///
	class func applyTableEndEditingButton(on controller:UIViewController, onClickInvoke selector:Selector)
	{
		// Add our custom button
		controller.navigationItem.rightBarButtonItem = UIBarButtonItem(
			 title:"Done",
			 style:UIBarButtonItemStyle.Done,
			target:controller,
			action:selector)
	}
	
	///
	/// Initializes the navbar style settings
	///
	class func initialize()
	{
		let appearance = UINavigationBar.appearance()
		appearance.barTintColor = NAVBAR_VIEW_BACKCOLOR
		appearance.tintColor = NAVBAR_VIEW_TINTCOLOR
		appearance.titleTextAttributes = textAttrs(NAVBAR_VIEW_FORECOLOR)
		appearance.translucent = true
		UIApplication.sharedApplication().statusBarStyle = NAVBAR_VIEW_STATUSSTYLE
		
		_currentContext = VIEW_CONTEXT
	}
	
	///
	/// Switches the navbar color to the 'Edit Context' colorscheme
	///
	class func usingEditContext(navigationController: UINavigationController?)
	{
		if (EDIT_CONTEXT != _currentContext) {
			if let navbar = navigationController?.navigationBar {
				navbar.barTintColor = NAVBAR_EDIT_BACKCOLOR
//				navbar.tintColor = NAVBAR_EDIT_TINTCOLOR // Potentially can change the image's color values as well
				navbar.titleTextAttributes = textAttrs(NAVBAR_VIEW_FORECOLOR)
				UIApplication.sharedApplication().statusBarStyle = NAVBAR_EDIT_STATUSSTYLE
				
				_currentContext = EDIT_CONTEXT
			}
		}
	}
	
	///
	/// Switches the navbar color to the 'View Context' colorscheme
	///
	class func usingViewContext(navigationController: UINavigationController?)
	{
		if (VIEW_CONTEXT != _currentContext) {
			if let navbar = navigationController?.navigationBar {
				navbar.barTintColor = NAVBAR_VIEW_BACKCOLOR
				navbar.tintColor = NAVBAR_VIEW_TINTCOLOR
				navbar.titleTextAttributes = textAttrs(NAVBAR_VIEW_FORECOLOR)
				UIApplication.sharedApplication().statusBarStyle = NAVBAR_VIEW_STATUSSTYLE
				_currentContext = VIEW_CONTEXT
			}
		}
	}

	
	///////////////////////////////////////////////////////// HELPER METHODS ///
	
	///
	/// Image factory for bundled resources intended for use in the navbar
	///
	private class func image(imageName:String) -> UIImage
	{
		return UIImage(named:imageName)!.imageWithRenderingMode(.AlwaysOriginal)
	}
	
	///
	/// Sets the left button item for the nav controller
	///
	private class func setLeftButton(controller:UIViewController, imageName:String)
	{
		let navbar = controller.navigationController!.navigationBar
		navbar.backIndicatorImage = image(imageName)
		navbar.backIndicatorTransitionMaskImage = image(imageName)
		
		controller.navigationItem.backBarButtonItem = UIBarButtonItem(
			title:" ",
			style:.Plain,
			target:nil,
			action:nil)
	}
	
	///
	/// Sets the right button item for the nav controller and binds an action
	///
	private class func setRightButton(controller:UIViewController, imageName:String, selector:Selector)
	{
		controller.navigationItem.rightBarButtonItem = UIBarButtonItem(
			image:image(imageName),
			style:.Plain,
			target:controller,
			action:selector)
	}
	
	///
	/// Creates a dictionary containing text attributes
	///
	private class func textAttrs(color: UIColor) -> NSDictionary
	{
//		let textShadow = NSShadow()
//		textShadow.shadowBlurRadius = 0.1
//		textShadow.shadowColor = SHADOWCOLOR
//		textShadow.shadowOffset = CGSize(width: 0, height: 1)
		
		var attributes = NSMutableDictionary()
		attributes.setValue(color, forKey: NSForegroundColorAttributeName)
		attributes.setValue(UIFont(name: "HelveticaNeue-Light", size: 18), forKey: NSFontAttributeName)
//		attributes.setValue(textShadow, forKey: NSShadowAttributeName)
		
		return attributes
	}
}