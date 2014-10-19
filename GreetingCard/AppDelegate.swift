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

	var window: UIWindow?
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		// Override point for customization after application launch.
		
		prototype_import_encoded_card()
		
		return true
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	private func prototype_import_encoded_card()
	{
		debug_dump_home_directory()
		
		//
		// 'Import Card' prototype
		//
		var HARDCODED_IMPORT_DATA:String? = "eyIkb3JpZ2luIjogImluc3RhbGxlciIsICIkdmVyc2lvbiI6ICIxLjAuMCIsICJjYXJkcyI6IFt7InRpdGxlIjogInNhbXBsZV9pbXBvcnRlZF9jYXJkIiwgImlzTmV3IjogdHJ1ZSwgInNjZW5lcyI6IFt7ImxheWVycyI6IFt7InNjYWxlIjogMC40MywgInRvcCI6IDAsICJyb3RhdGlvbiI6IDAsICJsZWZ0IjogMCwgInZpc2libGUiOiB0cnVlLCAiaW1hZ2UiOiAiYmFja2Ryb3AteWVsbG93IiwgIm9wYWNpdHkiOiAxIH0gXSwgImNhcHRpb24iOiAiVGhpcyBjYXJkIGlzIHRoZSByZXN1bHQgb2YgYW4gaW1wb3J0IG9wZXJhdGlvbiJ9IF0gfSBdIH0g"
		
		if let encodedCardstore = HARDCODED_IMPORT_DATA? {
			importCardstore(from:encodedCardstore)
		}
	}
	
	private func debug_dump_home_directory()
	{
		println("**************************************** DEBUGGING AIDS ****************************************")
		println("Home Directory:\n\(NSHomeDirectory())")
		println("*************************************************************************************************")
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

