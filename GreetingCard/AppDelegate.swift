//
//  AppDelegate.swift
//  GreetingCard
//
//  Created by David Bazile on 9/28/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	private let IMPORT_CARD = "import"

	var window: UIWindow?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		if (!DataUtility.IsInstalled()) {
			DataUtility.Install()
		}
		
		Decorator.initialize()
		
		return true
	}
	
	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String, annotation: AnyObject?) -> Bool {
		if let action = url.host {
			
			switch (action) {
				case IMPORT_CARD:
					DataUtility.Import(url.lastPathComponent)
					return true
				default:
					handleInvalidUrlAction()
			}
		}
		
		return false
	}
	
	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
		
		// Save often
		DataUtility.Save()
	}
	
	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	// MARK: HELPER METHODS ////////////////////////////////////////////////////
	
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	private func debug_dump_home_directory()
	{
		println("**************************************** DEBUGGING AIDS *****************************************")
		println("Home Directory:\n\(NSHomeDirectory())")
		println("*************************************************************************************************")
	}
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	
	///
	/// Executed when an invalid url action is encountered
	///
	private func handleInvalidUrlAction()
	{
		// Note: AlertView is deprecated in ios8
		let alert = UIAlertView(title: "OH NOES!", message: "You got a broken link from somewhere", delegate: nil, cancelButtonTitle: "K")
		alert.show()
		println("********* URL action failed **********")
	}
	
	///
	/// Performs an import
	///
	private func importCardstore(from encodedString: String)
	{
		println("[appdelegate:importCardstore -> attempting to import from encoded cardstore]")
		
		if let card = DataUtility.Import(encodedString) {
			println("[appdelegate:importCardstore -> successfully imported '\(card.title)'; forwarding to viewer]")
			//
			// TODO: Send to the viewer!
			//
		} else {
			println("[appdelegate:importCardstore -> found no card to import]")
		}
		
	}
}

