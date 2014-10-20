//
//  DataUtilityTest.swift
//  GreetingCard
//
//  Created by David Bazile on 10/19/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import Foundation
import UIKit
import XCTest
import GreetingCard

class DataUtilityTest: XCTestCase {
	private let BASE64_ENCODED_CARD = "eyIkb3JpZ2luIjogInhjb2RlLXVuaXR0ZXN0IiwgIiR2ZXJzaW9uIjogIjEiLCAiJGNhcmRzIjogW3sidGl0bGUiOiAiYnJhdm8genVsdSIsICJpc05ldyI6IGZhbHNlLCAic2NlbmVzIjogW3sibGF5ZXJzIjogW3sic2NhbGUiOiAwLjQzLCAidG9wIjogMCwgInJvdGF0aW9uIjogMCwgImxlZnQiOiAwLCAidmlzaWJsZSI6IHRydWUsICJpbWFnZSI6ICJiYWNrZHJvcC15ZWxsb3ciLCAib3BhY2l0eSI6IDEgfSBdLCAiY2FwdGlvbiI6ICJkZWx0YSBicmF2byJ9IF0gfSBdIH0g"
    override func setUp() {
        super.setUp()
		
		DataUtility.Install()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
		
		removeInstallationArtifacts()
    }

	func testAllCards()
	{
		let cards = DataUtility.AllCards
		
		XCTAssertGreaterThan(cards.count, 0, "Should have at least one card")
		
		for card in cards {
			
			XCTAssertNotEqual(card.title, "", "Card must have a title")
			XCTAssertGreaterThan(card.scenes.count, 0, "Card should have at least one scene")
			
			for scene in card.scenes {
				
				XCTAssertNotEqual(scene.caption, "", "Scene must have a caption")
				XCTAssertGreaterThan(scene.layers.count, 0, "Scene must have at least one layer")
				
				for layer in scene.layers {
					
					XCTAssertNotEqual(layer.image, "", "Layer must have an image")
				}
			}
		}
	}
	
	func testAllLocalSprites()
	{
		let sprites = DataUtility.AllLocalSprites
		
		XCTAssertGreaterThan(sprites.count, 5, "Should be at least five sprites")
		
		let fs = NSFileManager.defaultManager()
		for sprite in sprites {
			
			XCTAssertNotEqual(sprite, "", "Sprite must have an identifier")
			XCTAssertTrue(fs.fileExistsAtPath("~/Library/Caches/SpriteRepository/\(sprite).png".stringByExpandingTildeInPath), "Sprite should exist in the local sprite repository")
		}
	}
	
	func testCreateLayer() {
		let image = "test-image"
		let layer = DataUtility.CreateLayer(image)
		
		XCTAssertEqual(layer.image, image, "New layer should have the referenced image")
	}
	
	func testCreateScene()
	{
		let scene = DataUtility.CreateScene()
		
		XCTAssertEqual(scene.caption, "", "Caption should be blank")
		XCTAssertEqual(scene.layers.count, 0, "Layers list should be empty")
	}
	
	func testExport()
	{
		let expectedCardTitle = "bravo zulu"
		
		let card = Card(title:expectedCardTitle, isNew:false, scenes:nil)
		
		let export = DataUtility.Export(card)

		let json = NSString(data:NSData(base64EncodedString:export, options:nil), encoding:NSUTF8StringEncoding)
		
		XCTAssertNotNil(json.rangeOfString("\\{.*\\}", options: .RegularExpressionSearch), "Should be a JSON string")
		XCTAssertNotNil(json.rangeOfString("\\$cards", options: .RegularExpressionSearch), "Should contain the $cards property")
		XCTAssertNotNil(json.rangeOfString(expectedCardTitle, options: .RegularExpressionSearch), "Should contain the card title")
	}
	
	func testImport()
	{
		let startingCardCount = DataUtility.AllCards.count
		let card = DataUtility.Import(BASE64_ENCODED_CARD)
		
		XCTAssertEqual(DataUtility.AllCards.count, startingCardCount+1, "Imported card should be saved immediately")
		
		XCTAssertNotNil(card, "Card should not be nil")
		XCTAssertEqual(card!.title, "bravo zulu", "Card should have the testing title")
		XCTAssertEqual(card!.scenes.count, 1, "Card should have only one scene")
		XCTAssertEqual(card!.scenes[0].caption, "delta bravo", "Scene should have the testing caption")
		XCTAssertEqual(card!.scenes[0].layers.count, 1, "Scene should have only one layer")
		XCTAssertEqual(card!.scenes[0].layers[0].image, "backdrop-yellow", "Layer image should be yellow backdrop")
	}
	
	func testIsInstalled()
	{
		removeInstallationArtifacts()
		
		XCTAssertFalse(DataUtility.IsInstalled(), "After wiping, should not be installed")
		
		DataUtility.Install()
		
		XCTAssertTrue(DataUtility.IsInstalled(), "After installing, should be installed")
		
		removeInstallationArtifacts()
		XCTAssertFalse(DataUtility.IsInstalled(), "After wiping again, should not be installed")
	}
	
	func testResolve()
	{
		XCTAssertNotNil(DataUtility.Resolve("backdrop-yellow"), "'backdrop-yellow' should resolve locally")
		XCTAssertNotNil(DataUtility.Resolve("backdrop-red"), "'backdrop-red' should resolve remotely")
		XCTAssertNil(DataUtility.Resolve("ZZZZ"), "'ZZZZ' should return nil")
	}
	
	func testSave()
	{
		// Import covers Save
	}

	func testPerformanceOfInstall() {
		self.measureBlock() {
			DataUtility.Install()
		}
	}
	
	private func removeInstallationArtifacts()
	{
		let fs = NSFileManager.defaultManager()
		fs.removeItemAtPath("~/Documents/cardstore.json".stringByExpandingTildeInPath, error:nil)
		fs.removeItemAtPath("~/Library/Caches/SpriteRepository".stringByExpandingTildeInPath, error:nil)
	}

}
