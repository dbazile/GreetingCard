//
//  DataUtility.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import Foundation
//import Alamofire

private let DEBUG_FORCE_INSTALL = true
private let CARDSTORE_PATH  = "~/Documents/cardstore.json".stringByExpandingTildeInPath
private let REPOSITORY_PATH = "~/Library/Caches/SpriteRepository".stringByExpandingTildeInPath
private let MANIFEST_PATH   = "~/Library/Caches/SpriteRepository/manifest.json".stringByExpandingTildeInPath
private let ORIGIN_INSTALLER = "installer"
private let REMOTE_REPOSITORY_URL = "http://127.0.0.1:8000/sprites/"

// Schema
private let MANIFEST_SCHEMA_VERSION = "1"
private let CARDSTORE_SCHEMA_VERSION = "1"
private let KEY_ORIGIN  = "$origin"
private let KEY_VERSION = "$version"
private let KEY_CARDS   = "$cards"
private let KEY_SPRITES = "$sprites"

private var _allCards : [Card]?
private var _allLocalSprites : [String]?

class DataUtility
{
	
	// MARK: PUBLIC INTERFACE //////////////////////////////////////////////////
	
	///
	/// Static property for all cards
	///
	class var AllCards : [Card] {
		if (nil == _allCards) {
			_allCards = cards_read()
		}
		
		return _allCards!
	}
	
	///
	/// Static property for local sprite identifiers
	///
	class var AllLocalSprites : [String] {
		if (nil == _allLocalSprites) {
			_allLocalSprites = manifest_read()
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
		println("[du:Export -> exporting base64-encoded card]")
		return encode(serialize(cards:[card]))
	}
	
	///
	/// Imports a Card object from a base64 encoded string
	///
	class func Import(encodedCard: String) -> Card?
	{
		println("[du:Import -> attempting to import base64-encoded card]")
		
		if let newCard = unserialize(cards:decode(encodedCard)).first {
			
			// Precache each layer sprite
			for scene in newCard.scenes {
				for layer in scene.layers {
					Resolve(layer.image)
				}
			}
			
			// Make sure the cardstore is initialized
			_allCards = cards_read()
			_allCards!.append(newCard)
			
			Save()
			
			return newCard
		} else {
			return nil
		}
	}
	
	///
	/// Set things up for the first time
	///
	class func Install()
	{
		func _generateCards() -> [Card]
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
		
		func _generateSpriteManifest() -> [String]
		{
			// Create the local sprite repository
			let fs = NSFileManager.defaultManager()
			let repository = REPOSITORY_PATH.stringByExpandingTildeInPath
			fs.removeItemAtPath(repository, error:nil)
			fs.createDirectoryAtPath(repository, withIntermediateDirectories:true, attributes:nil,  error:nil)
			
			// Copy the files from the bundle to the local repository
			var identifiers: [String] = []
			let bundledSprites = NSBundle.mainBundle().pathsForResourcesOfType("png", inDirectory: "starterkit") as [String]
			for source in bundledSprites {
				let filename = source.lastPathComponent
				let identifier = filename.stringByDeletingPathExtension
				let destination = repository.stringByAppendingPathComponent(filename)
				
				// Copy the file
				fs.copyItemAtPath(source, toPath: destination, error: nil)
				
				// Add the sprite to the manifest
				identifiers.append(identifier)
			}
			
			return identifiers
		}
		
		println("[du:Install -> installing cardstore starter kit]")
		cards_write(_generateCards())
		
		println("[du:Install -> installing sprite starter kit]")
		manifest_write(_generateSpriteManifest())
	}
	
	///
	/// Tests whether or not the cardstore has been created.
	///
	class func IsInstalled() -> Bool
	{
		let cardstore = CARDSTORE_PATH.stringByExpandingTildeInPath
		if (DEBUG_FORCE_INSTALL) {
			println("[du:IsInstalled -> forcing install; `DEBUG_FORCE_INSTALL` is set to true]")
			return false
		} else {
			let fs = NSFileManager.defaultManager()
			return fs.fileExistsAtPath(cardstore)
		}
	}

	///
	/// Resolves a sprite identifier to a local file path
	///
	/// If the sprite is not present in the local repository, this function
	/// will attempt to retrieve it from the remote repository and cache it
	/// locally.  If that fails, it will return nil.
	///
	class func Resolve(identifier:String) -> String?
	{
		let path = REPOSITORY_PATH.stringByExpandingTildeInPath
			                      .stringByAppendingPathComponent(identifier)
			                      .stringByAppendingPathExtension("png")!
		
		let fs = NSFileManager.defaultManager()
		if (fs.fileExistsAtPath(path)) {
			return path
		} else {
			return fetchRemoteSprite(identifier)
		}
	}
	
	///
	/// Saves the cards in memory to disk
	///
	class func Save()
	{
		println("[du:Save -> attempting to save \(AllCards.count) cards]")
		
		cards_write(AllCards)
	}


	// MARK: HELPER METHODS ////////////////////////////////////////////////////

	///
	/// Adds a list of sprite identifiers to the local repository manifest
	///
	private class func appendSpritesToManifest(identifiers: [String])
	{
		println("[du:appendSpritesToManifest -> \(identifiers)]")
		
		// Append to the local sprite list
		_allLocalSprites = manifest_read() + identifiers
		_allLocalSprites!.sort({ (a: String, b:String) -> Bool in return a < b })
		
		// Save new manifest
		manifest_write(_allLocalSprites!)
	}
	
	///
	/// Reads all cards from the local JSON store
	///
	private class func cards_read() -> [Card]
	{
//		
//		/*
//		 * Ideally, this would live somewhere in the AppDelegate.  But since I
//		 * don't know how to do that just yet without blowing up various view
//		 * controllers, we'll just leave it here for now.
//		 */
//		if (!IsInstalled()) {
//			Install()
//		}
//		
		let path = CARDSTORE_PATH.stringByExpandingTildeInPath
		println("[du:cards_read -> '\(path.stringByAbbreviatingWithTildeInPath)']")
		let json = NSString(contentsOfFile:path, encoding:NSUTF8StringEncoding, error:nil)
		
		return unserialize(cards: json)
	}
	
	///
	/// Writes the JSON string to the cards file
	///
	private class func cards_write(cards: [Card])
	{
		let json = serialize(cards:cards)
		let path = CARDSTORE_PATH.stringByExpandingTildeInPath
		
		println("[du:cards_write -> '\(path.stringByAbbreviatingWithTildeInPath)']")
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
	/// Retrieves a sprite from the remote repository
	///
	private class func fetchRemoteSprite(identifier: String) -> String?
	{
		let filename = identifier.stringByAppendingPathExtension("png")!
		let spriteUrl = NSURL(string: filename,
			relativeToURL: NSURL(string: REMOTE_REPOSITORY_URL))
		
		println("[du:fetchRemoteSprite -> '\(spriteUrl.absoluteString!)']")
		if let data = NSData.dataWithContentsOfURL(spriteUrl, options: nil, error: nil) {
			let path = REPOSITORY_PATH//.stringByExpandingTildeInPath
				.stringByAppendingPathComponent(filename)
			if (data.writeToFile(path, atomically: true)) {
				appendSpritesToManifest([identifier])
				
				return path
			} else {
				println("[du:fetchRemoteSprite] Save failed for '\(path.stringByAbbreviatingWithTildeInPath)']")
				return nil
			}
		} else {
			println("[du:fetchRemoteSprite] Fetch failed")
			return nil
		}
	}
	
	///
	/// Retrieves a list of identifiers from the local sprite repository
	///
	private class func manifest_read() -> [String]
	{
		let path = MANIFEST_PATH.stringByExpandingTildeInPath
		
		println("[du:manifest_read -> '\(path.stringByAbbreviatingWithTildeInPath)']")
		
		let data = NSData.dataWithContentsOfFile(path, options: nil, error: nil)
		let raw = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
		
		return raw[KEY_SPRITES] as [String]
	}
	
	///
	/// Writes a list of identifiers to the local sprite repository
	///
	private class func manifest_write(identifiers: [String])
	{
		let path = MANIFEST_PATH.stringByExpandingTildeInPath
		
		println("[du:manifest_write -> '\(path.stringByAbbreviatingWithTildeInPath)']")
		
		let json = serialize(sprites: identifiers)
		
		json.writeToFile(path, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
	}
	
	///
	/// Serializes a collection of cards to JSON
	///
	private class func serialize(#cards: [Card]) -> String
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
//			println("[du:serialize -> working on card '\(card.title)']")
			
			var item = NSMutableDictionary()
			
			item["title"] = card.title
			item["isNew"] = card.isNew
			item["scenes"] = card.scenes.map(_scene)
			
			return item
		}
		
		var wrapper = NSMutableDictionary()
		wrapper[KEY_VERSION] = CARDSTORE_SCHEMA_VERSION
		wrapper[KEY_ORIGIN] = ORIGIN_INSTALLER
		wrapper[KEY_CARDS] = cards.map(_card)
		
		let bytes = NSJSONSerialization.dataWithJSONObject(wrapper, options:nil, error:nil)
		let output = NSString(data:bytes!, encoding: NSUTF8StringEncoding)
		
		return output
	}
	
	///
	/// Serializes the manifest for the local sprite repository
	///
	private class func serialize(sprites identifiers: [String]) -> String
	{
		var wrapper = NSMutableDictionary()
		wrapper.setValue(MANIFEST_SCHEMA_VERSION, forKey: KEY_VERSION)
		wrapper.setValue(ORIGIN_INSTALLER, forKey: KEY_ORIGIN)
		wrapper.setValue(identifiers, forKey: KEY_SPRITES)
		
		let bytes = NSJSONSerialization.dataWithJSONObject(wrapper, options:nil, error:nil)
		return NSString(data:bytes!, encoding: NSUTF8StringEncoding)
	}
	
	///
	/// Unserializes a collection of cards from a JSON string
	///
	private class func unserialize(cards json:String) -> [Card]
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
		let version = wrapper[KEY_VERSION] as String
		println("[du:unserialize -> now parsing json cardstore (v\(version))]")
		
		// Perform the operation
		let cards = (wrapper[KEY_CARDS] as [NSDictionary]).map(_card)
		
		// Emit metrics
		println("[du:unserialize -> extracted \(cards.count) cards]")
		
		return cards
	}

	///
	/// Unserializes the manifest for the local sprite repository
	///
	private class func unserialize(sprites json: String) -> [String]
	{
		let bytes = json.dataUsingEncoding(NSUTF8StringEncoding)!
		let wrapper = NSJSONSerialization.JSONObjectWithData(bytes, options: nil, error: nil) as NSDictionary
		
		return wrapper[KEY_SPRITES] as [String]
	}
}
