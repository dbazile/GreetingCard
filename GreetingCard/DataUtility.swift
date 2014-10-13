//
//  DataUtility.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import Foundation
import Alamofire

class DataUtility
{

	///
	/// Returns a list of all cards stored locally
	///
	class func AllCards() -> [Card]
	{
//		Alamofire.request(.GET, "http://andsoitcontinues.com/sample_data/music.json")
//			.responseJSON { (request, response, json, error) in
//				let data = (json as NSArray)[0] as NSDictionary
//				println(data["album_title"])
//		}
		
		return ReadCardsFromLocalJson()
	}
	
	
	
	
	
	
	
	
	private class func ReadCardsFromLocalJson() -> [Card]
	{
		let path = NSBundle.mainBundle().pathForResource("cards", ofType: ".json") as String!
		let jsonString = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)

		return unserialize(jsonString)
	}
	
	
	
	
	

	///
	/// Returns a list of identifiers for all local sprites
	///
	class func AllLocalSprites() -> [String]
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
	
	///
	/// Factory method for layers
	///
	class func createLayer(image:String) -> Layer
	{
		return Layer(image:image, visible:true, scale:0.5, rotation:0, opacity:1.0, top:0, left:0)
	}

	///
	/// Factory method for scenes
	///
	class func createScene() -> Scene
	{
		return Scene(caption:nil, layers:nil)
	}

	///
	/// Resolves an image identifier to its absolute file path
	///
	class func resolve(identifier:String) -> String
	{
		return png(identifier)!
	}






	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG

	class func GenerateCards() -> [Card]
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

		cards.append(GenerateCard("Merry Christmas!"))

		return cards
	}

	class func GenerateCard(title:String) -> Card
	{
		var scenes: [Scene] = []

		scenes.append(GenerateScene("The cat's in the cradle with the silver spoon"))
		scenes.append(GenerateScene("Little boy blue and the man in the moon"))
		scenes.append(GenerateScene("When you coming home dad"))
		scenes.append(GenerateScene("I don't know when, but we'll get together then"))

		return Card(title: title, isNew: true, scenes: scenes)
	}

	class func GenerateScene(caption: String) -> Scene
	{
		return Scene(caption: caption, layers: [])
	}

	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG
	// DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG DEBUG






	// MARK: HELPER METHODS ////////////////////////////////////////////////////

	///
	/// Resolves the full path to a given .PNG file
	///
	private class func png(basename: String) -> String?
	{
		return NSBundle.mainBundle().pathForResource(basename, ofType:".png", inDirectory:"sprites")
	}
	
	
	
	
	
	
	
	
	
	
	private class func serialize(cards: [Card]) -> String
	{
		func _layers(layers: [Layer]) -> [NSDictionary]
		{
			var container: [NSDictionary] = []
			
			for layer in layers {
				var convertedLayer = NSMutableDictionary()
				
				convertedLayer["image"] = layer.image
				convertedLayer["left"] = layer.left
				convertedLayer["opacity"] = layer.opacity
				convertedLayer["rotation"] = layer.rotation
				convertedLayer["scale"] = layer.scale
				convertedLayer["top"] = layer.top
				convertedLayer["visible"] = layer.visible
				
				container.append(convertedLayer)
			}
			
			return container
		}
		
		func _scenes(scenes:[Scene]) -> [NSDictionary]
		{
			var container: [NSDictionary] = []
			
			for scene in scenes {
				var convertedScene = NSMutableDictionary()
				
				convertedScene["caption"] = scene.caption
				convertedScene["layers"] = _layers(scene.layers)
				
				container.append(convertedScene)
			}
			
			return container
		}
		
		var root = NSMutableDictionary()
		var container = NSMutableArray()
		
		root["$version"] = "1.0.0"
		root["$origin"] = "installer"
		root["cards"] = container
		
		for card in cards {
			var item = NSMutableDictionary()
			
			println("[data-util:serialize -> working on card '\(card.title)']")
			
			item["title"] = card.title
			item["isNew"] = card.isNew
			
			item.setValue(_scenes(card.scenes), forKey:"scenes")
			
			container.addObject(item)
		}
		
		let bytes = NSJSONSerialization.dataWithJSONObject(root, options:nil, error:nil)
		let output = NSString(data:bytes!, encoding: NSUTF8StringEncoding)
		
		println("[data-util:serialize -> operation complete, JSON data follows]")
		println(output)
		println()
		
		return output
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	private class func unserialize(json:String) -> [Card]
	{
		func _layers(raw: AnyObject?) -> [Layer]
		{
			var layers: [Layer] = []
			
			if let rawLayers = raw as NSArray? {
				
				for rawLayer in rawLayers {
					let layer = Layer(
						image: rawLayer["image"] as String,
						visible: rawLayer["visible"] as Bool,
						scale: rawLayer["scale"] as Float,
						rotation: rawLayer["rotation"] as Int,
						opacity: rawLayer["opacity"] as Float,
						top: rawLayer["top"] as Int,
						left: rawLayer["left"] as Int)
					
					layers.append(layer)
				}
				
			}
			
			return layers
		}
		
		
		func _scenes(raw: AnyObject?) -> [Scene]
		{
			var scenes: [Scene] = []
			
			if let rawScenes = raw as NSArray? {
				
				for rawScene in rawScenes {
					let scene = Scene(caption:rawScene["caption"] as String!, layers: _layers(rawScene["layers"]))
					
					scenes.append(scene)
				}
			}
			
			return scenes
		}
		
		
		var cards: [Card] = []
		
		let data = json.dataUsingEncoding(NSUTF8StringEncoding)!
		let rawContainer = NSJSONSerialization.JSONObjectWithData(data, options:nil, error:nil) as NSDictionary
		
		let version = rawContainer["$version"] as String?
		println("[data-util:unserialize -> now parsing cards.json (v\(version))]")
		
		let rawCards = rawContainer.valueForKey("cards") as [NSDictionary]
		
		for rawcard in rawCards {
			let title = rawcard["title"] as String?
			println("[data-util:unserialize -> working on raw card '\(title)']")
			let card = Card(title:rawcard["title"] as String!, isNew:rawcard["isNew"] as Bool!, scenes: _scenes(rawcard["scenes"]))
			
			cards.append(card)
		}
		
		println("[data-util:unserialize -> operation complete, data follows]")
		println(cards)
		
		return cards
	}
	

	
	
	
	
	
	
	
	class func Export(card: Card) -> String
	{
		println("[data-util:Export -> exporting base64-encoded card]")
		return encode(serialize([card]))
	}
	
	class func Import(encoded: String) -> Card?
	{
		println("[data-util:Import -> attempting to import base64-encoded card]")
		return unserialize(decode(encoded)).first
	}
	
	private class func decode(encoded:String) -> String
	{
		let data = NSData(base64EncodedString:encoded, options:nil)
		return NSString(data:data, encoding:NSUTF8StringEncoding)
	}
	
	private class func encode(plaintext:String) -> String
	{
		let data = plaintext.dataUsingEncoding(NSUTF8StringEncoding)!
		return data.base64EncodedStringWithOptions(nil)
	}
	
}
