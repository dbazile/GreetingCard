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
		
		debug_dump_home_directory()
		
		if (!DataUtility.IsInstalled()) {
			DataUtility.Install()
		}

		prototype_import_encoded_card()
		
		return false
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	private func prototype_import_encoded_card()
	{
		//
		// 'Import Card' prototype
		//
		var HARDCODED_IMPORT_DATA:String? = "eyIkb3JpZ2luIjogImRhdGEtZGlhZ25vc3RpY3MiLCAiJHZlcnNpb24iOiAiMSIsICIkY2FyZHMiOiBbeyJ0aXRsZSI6ICJzYW1wbGVfaW1wb3J0ZWRfY2FyZCIsICJpc05ldyI6IHRydWUsICJzY2VuZXMiOiBbeyJsYXllcnMiOiBbeyJzY2FsZSI6IDAuNDMsICJ0b3AiOiAwLCAicm90YXRpb24iOiAwLCAibGVmdCI6IDAsICJ2aXNpYmxlIjogdHJ1ZSwgImltYWdlIjogImJhY2tkcm9wLXJlZCIsICJvcGFjaXR5IjogMSB9IF0sICJjYXB0aW9uIjogIlRoaXMgY2FyZCBpcyB0aGUgcmVzdWx0IG9mIGFuIGltcG9ydCBvcGVyYXRpb24ifSBdIH0gXSB9IA=="
		
		if let encodedCardstore = HARDCODED_IMPORT_DATA? {
			importCardstore(from:encodedCardstore)
		}
	}
	
	private func debug_dump_home_directory()
	{
		println("**************************************** DEBUGGING AIDS *****************************************")
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

