//
//  DataUtility.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import Foundation
import Alamofire

private let DEBUG_FORCE_INSTALL = true
private let SCHEMA_VERSION = "1.0.0"

private var _allCards : [Card]?
private var _allLocalSprites : [String]?

class DataUtility
{
	
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	private class func debug_HardcodedSpriteDefinition() -> [String]
	{
		var paths: [String] = []
		
		paths.append("backdrop-home-indoors")
		paths.append("backdrop-road")
		paths.append("backdrop-yellow")
		paths.append("cake")
		paths.append("home-bed")
		paths.append("home-sink")
		paths.append("home-table")
		paths.append("person")
		paths.append("road-car-front")
		
		return paths
	}
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	
	
	
	
	
	// MARK: PUBLIC INTERFACE //////////////////////////////////////////////////
	
	///
	/// Static property for all cards
	///
	class var AllCards : [Card] {
		if (nil == _allCards) {
			if (!IsInstalled()) {
				Install()
			}
			_allCards = cards_read()
		}
		
		return _allCards!
	}
	
	///
	/// Static property for local sprite identifiers
	///
	class var AllLocalSprites : [String] {
		if (nil == _allLocalSprites) {
			_allLocalSprites = debug_HardcodedSpriteDefinition()
		}
		
		return _allLocalSprites!
	}
	
	///
	/// Factory method for layers
	///
	class func CreateLayer(image:String) -> Layer
	{
		return Layer(image:image, visible:true, scale:0.5, rotation:0, opacity:1.0, top:0, left:0)
	}

	///
	/// Factory method for scenes
	///
	class func CreateScene() -> Scene
	{
		return Scene(caption:nil, layers:nil)
	}

	///
	/// Exports a base64 encoded string from a Card object
	///
	class func Export(card: Card) -> String
	{
		println("[data-util:Export -> exporting base64-encoded card]")
		return encode(serialize([card]))
	}
	
	///
	/// Imports a Card object from a base64 encoded string
	///
	class func Import(encodedCard: String) -> Card?
	{
		println("[data-util:Import -> attempting to import base64-encoded card]")
		return unserialize(decode(encodedCard)).first
	}
	
	///
	/// Set things up for the first time
	///
	class func Install()
	{
		func _cards() -> [Card]
		{
			var cards: [Card] = []
			
			cards.append(
				Card(title: "Another Day in the Life", isNew: true, scenes: [
					Scene(caption: "It's time to wake up, Dave.", layers: [
						Layer(image: "backdrop-home-indoors", visible: true, scale: 0.43, rotation: 0, opacity: 1.0, top: 0, left: 0),
						Layer(image: "home-bed", visible: true, scale: 0.3, rotation: 0, opacity: 1.0, top: 300, left: 70),
						Layer(image: "person", visible: true, scale: 0.3, rotation: 0, opacity: 1.0, top: 230, left: 150)
						]),
					Scene(caption: "Brush your teeth so you don't have the dragon breath!", layers: [
						Layer(image: "backdrop-home-indoors", visible: true, scale: 0.43, rotation: 0, opacity: 1.0, top: 0, left: 0),
						Layer(image: "home-sink", visible: true, scale: 0.3, rotation: 0, opacity: 1.0, top: 350, left: 120),
						Layer(image: "person", visible: true, scale: 0.3, rotation: 0, opacity: 1.0, top: 350, left: 190)
						]),
					Scene(caption: "They say breakfast is the most important meal of the day.", layers: [
						Layer(image: "backdrop-home-indoors", visible: true, scale: 0.43, rotation: 0, opacity: 1.0, top: 0, left: 0),
						Layer(image: "home-table", visible: true, scale: 0.3, rotation: 0, opacity: 1.0, top: 310, left: 80),
						Layer(image: "person", visible: true, scale: 0.3, rotation: 0, opacity: 1.0, top: 157, left: 110)
						]),
					Scene(caption: "And then he drives to work for a new day of fun and excitement!", layers: [
						Layer(image: "backdrop-road", visible: true, scale: 0.43, rotation: 0, opacity: 1.0, top: 0, left: 0),
						Layer(image: "person", visible: true, scale: 0.09, rotation: 0, opacity: 0.7, top: 152, left: 41),
						Layer(image: "road-car-front", visible: true, scale: 0.13, rotation: 0, opacity: 1.0, top: 140, left: 0)
						])
					])
			)
			
			cards.append(
				Card(title: "Happy Birthday", isNew: true, scenes: [
					Scene(caption: "It is your birthday.", layers: [
						Layer(image: "backdrop-yellow", visible: true, scale: 0.43, rotation: 0, opacity: 1.0, top: 0, left: 0),
						Layer(image: "cake", visible: true, scale: 0.5, rotation: 0, opacity: 1.0, top: 0, left: 0)
						]),
					Scene(caption: "Now get back to work.", layers: [
						Layer(image: "person", visible: true, scale: 0.43, rotation: 0, opacity: 1.0, top: 0, left: 0)
						])
					])
			)
			
			return cards
		}
		
		/*
		 * Notes:
		 * 2014-10-13 -- While this does technically work, I still need to think
		 * about how I'm going to do the sprite repository I/O.
		 */
		func _sprites() -> [String]
		{
			let fs = NSFileManager.defaultManager()
			let res = NSBundle.mainBundle()
			let path = res.resourcePath!.stringByAppendingPathComponent("sprites")
			let files = fs.contentsOfDirectoryAtPath(path, error:nil) as [String]
			
			return files.map({ "\($0)".stringByDeletingPathExtension })
		}
		
		println("[data-util:Install -> installing cardstore starter kit]")
		cards_write(serialize(_cards()))
		
//		println("[data-util:Install -> installing sprite starter kit]")
//		println(_sprites())
	}
	
	///
	/// Tests whether or not the cardstore has been created.
	///
	class func IsInstalled() -> Bool
	{
		if (DEBUG_FORCE_INSTALL) {
			println("[data-util:IsInstalled -> forcing install; `DEBUG_FORCE_INSTALL` is set to true]")
			return false
		} else {
			let fs = NSFileManager.defaultManager()
			return fs.fileExistsAtPath(pathJson("cards"))
		}
	}
	
	///
	/// Resolves an image identifier to its absolute file path
	///
	class func Resolve(identifier:String) -> String
	{
		return pathPng(identifier)!
	}
	
	///
	/// Saves the cards in memory to disk
	///
	class func Save()
	{
		println("[data-util:Save -> attempting to save \(AllCards.count) cards]")
		
		cards_write(serialize(AllCards))
	}
	

	// MARK: HELPER METHODS ////////////////////////////////////////////////////

	///
	/// Reads all cards from the local JSON store
	///
	private class func cards_read() -> [Card]
	{
		let path = pathJson("cards")
		println("[data-util:cards_read -> from '\(path.stringByAbbreviatingWithTildeInPath)']")
		let jsonString = NSString(contentsOfFile:path, encoding:NSUTF8StringEncoding, error:nil)
		
		return unserialize(jsonString)
	}
	
	///
	/// Writes the JSON string to the cards file
	///
	private class func cards_write(json: String)
	{
		let path = pathJson("cards")
		println("[data-util:cards_write -> to '\(path.stringByAbbreviatingWithTildeInPath)']")
		
		json.writeToFile(path, atomically:true, encoding:NSUTF8StringEncoding, error:nil)
	}
	
	///
	/// Converts a base64 encoded string into JSON
	///
	private class func decode(encoded:String) -> String
	{
		let data = NSData(base64EncodedString:encoded, options:nil)
		return NSString(data:data, encoding:NSUTF8StringEncoding)
	}
	
	///
	/// Converts a JSON string to base64 encoding
	///
	private class func encode(plaintext:String) -> String
	{
		let data = plaintext.dataUsingEncoding(NSUTF8StringEncoding)!
		return data.base64EncodedStringWithOptions(nil)
	}
	
	///
	/// Generates a path to a .JSON file.
	///
	/// *** This method returns a path whether or not the file exists! ***
	///
	private class func pathJson(basename: String) -> String
	{
		return NSHomeDirectory()
			.stringByAppendingPathComponent("Documents")
			.stringByAppendingPathComponent("com.andsoitcontinues.GreetingCard_")
			.stringByAppendingString(basename)
			.stringByAppendingPathExtension("json")!
	}
	
	///
	/// Returns the absolute path to a given .PNG file
	///
	private class func pathPng(basename: String) -> String?
	{
		let fs = NSBundle.mainBundle()
		return fs.pathForResource(basename, ofType:".png", inDirectory:"sprites")
	}

	///
	/// Serializes a collection of cards to JSON
	///
	private class func serialize(cards: [Card]) -> String
	{
		/// Map function: transforms a layer into an NSDictionary
		func _layer(layer: Layer) -> NSDictionary
		{
			var item = NSMutableDictionary()
			
			item["image"]    = layer.image
			item["left"]     = layer.left
			item["opacity"]  = layer.opacity
			item["rotation"] = layer.rotation
			item["scale"]    = layer.scale
			item["top"]      = layer.top
			item["visible"]  = layer.visible
				
			return item
		}
		
		/// Map function: transforms a scene into an NSDictionary
		func _scene(scene: Scene) -> NSDictionary
		{
			var item = NSMutableDictionary()
			
			item["caption"] = scene.caption
			item["layers"] = scene.layers.map(_layer)
			
			return item
		}
		
		/// Map function: transforms a card into an NSDictionary
		func _card(card: Card) -> NSDictionary
		{
			println("[data-util:serialize -> working on card '\(card.title)']")
			
			var item = NSMutableDictionary()
			
			item["title"] = card.title
			item["isNew"] = card.isNew
			item["scenes"] = card.scenes.map(_scene)
			
			return item
		}
		
		var cardstore = NSMutableDictionary()
		cardstore["$version"] = SCHEMA_VERSION
		cardstore["$origin"] = "installer"
		cardstore["cards"] = cards.map(_card)
		
		let bytes = NSJSONSerialization.dataWithJSONObject(cardstore, options:nil, error:nil)
		let output = NSString(data:bytes!, encoding: NSUTF8StringEncoding)
		
		return output
	}
	
	///
	/// Unserializes a collection of cards from a JSON string
	///
	private class func unserialize(json:String) -> [Card]
	{
		// Map function: Transforms a dictionary into a Layer
		func _layer(raw: NSDictionary) -> Layer
		{
			return Layer(image: raw["image"]    as String,
				       visible: raw["visible"]  as Bool,
				         scale: raw["scale"]    as Float,
				      rotation: raw["rotation"] as Int,
				       opacity: raw["opacity"]  as Float,
				           top: raw["top"]      as Int,
				          left: raw["left"]     as Int)
		}
		
		// Map function: Transforms a dictionary into a Scene
		func _scene(raw: NSDictionary) -> Scene
		{
			return Scene(caption: raw["caption"] as String!,
				          layers: (raw["layers"] as [NSDictionary]).map(_layer)
			)
		}
		
		// Map function: Transforms a dictionary into a Card
		func _card(raw: NSDictionary) -> Card
		{
			return Card(title: raw["title"] as String!,
				        isNew: raw["isNew"] as Bool,
				       scenes: (raw["scenes"] as [NSDictionary]).map(_scene)
			)
		}
		
		// Read the string into an NSDictionary structure
		let data = json.dataUsingEncoding(NSUTF8StringEncoding)!
		let wrapper = NSJSONSerialization.JSONObjectWithData(data, options:nil, error:nil) as NSDictionary
		
		// Emit some metrics
		let version = wrapper["$version"] as String
		println("[data-util:unserialize -> now parsing cards.json (v\(version))]")
		
		// Perform the operation
		let cards = (wrapper["cards"] as [NSDictionary]).map(_card)
		
		// Emit metrics
		println("data-util:unserialize -> extracted \(cards.count) cards")
		
		return cards
	}
}
