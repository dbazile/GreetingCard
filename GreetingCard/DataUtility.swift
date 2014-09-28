//
//  DataUtility.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import Foundation

class DataUtility {
	
	///
	/// Yields a prebuilt collection of cards
	///
	class func GenerateCards() -> [Card]
	{
		var cards: [Card] = []
		
		cards.append(generateCard("Happy Birthday!"))
		cards.append(generateCard("Merry Christmas!"))
		
		return cards
	}
	
	private class func generateCard(title:String) -> Card
	{
		var scenes: [Scene] = []
		
		scenes.append(generateScene("lorem"))
		scenes.append(generateScene("ipsum"))
		scenes.append(generateScene("dolor"))
		
		return Card(scenes: scenes, title: title, isNew: true)
	}
	
	private class func generateScene(caption: String) -> Scene
	{
		return Scene(layers: [], caption: caption)
	}
}