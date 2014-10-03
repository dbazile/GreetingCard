//
//  DataUtility.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import Foundation

class DataUtility {

	class func LoadCards() -> [Card]
	{
		//var cards: [Card] = []

		// Load some things from file, http, wherever

		//return cards
		return GenerateCards()
	}

	///
	/// Yields a prebuilt collection of cards
	///
	class func GenerateCards() -> [Card]
	{
		var cards: [Card] = []

		cards.append(
			Card(title: "Another Day in the Life", isNew: true, scenes: [
				Scene(caption: "It's time to wake up, Dave.", backgroundColor: nil, foregroundColor: nil, layers: [
					Layer(image: png("backdrop-home-indoors")!, visible: true, scale: 0.45, rotation: 0, opacity: 1.0, top: 0, left: 0),
					Layer(image: png("home-bed")!, visible: true, scale: 0.3, rotation: 0, opacity: 1.0, top: 300, left: 70),
					Layer(image: png("person")!, visible: true, scale: 0.3, rotation: 0, opacity: 1.0, top: 230, left: 150)
				]),
				Scene(caption: "Brush your teeth so you don't have the dragon breath!", backgroundColor: nil, foregroundColor: nil, layers: [
					Layer(image: png("backdrop-home-indoors")!, visible: true, scale: 0.45, rotation: 0, opacity: 1.0, top: 0, left: 0),
					Layer(image: png("home-sink")!, visible: true, scale: 0.3, rotation: 0, opacity: 1.0, top: 350, left: 120),
					Layer(image: png("person")!, visible: true, scale: 0.3, rotation: 0, opacity: 1.0, top: 350, left: 190)
				]),
				Scene(caption: "They say breakfast is the most important meal of the day.", backgroundColor: nil, foregroundColor: nil, layers: [
					Layer(image: png("backdrop-home-indoors")!, visible: true, scale: 0.45, rotation: 0, opacity: 1.0, top: 0, left: 0),
					Layer(image: png("home-table")!, visible: true, scale: 0.5, rotation: 0, opacity: 1.0, top: 0, left: 0),
					Layer(image: png("person")!, visible: true, scale: 0.5, rotation: 0, opacity: 1.0, top: 0, left: 0)
				]),
				Scene(caption: "And then he drives to work for a new day of fun and excitement!", backgroundColor: nil, foregroundColor: nil, layers: [
					Layer(image: png("backdrop-road")!, visible: true, scale: 0.45, rotation: 0, opacity: 1.0, top: 0, left: 0),
					Layer(image: png("person")!, visible: true, scale: 0.5, rotation: 0, opacity: 1.0, top: 0, left: 0),
					Layer(image: png("road-car-front")!, visible: true, scale: 0.5, rotation: 0, opacity: 1.0, top: 0, left: 0)
				])
			])
		)

		cards.append(
			Card(title: "Happy Birthday", isNew: true, scenes: [
				Scene(caption: "It is your birthday.", backgroundColor: nil, foregroundColor: nil, layers: [
					Layer(image: png("backdrop-yellow")!, visible: true, scale: 0.45, rotation: 0, opacity: 1.0, top: 0, left: 0),
					Layer(image: png("cake")!, visible: true, scale: 0.5, rotation: 0, opacity: 1.0, top: 0, left: 0)
					]),
				Scene(caption: "Now get back to work.", backgroundColor: nil, foregroundColor: nil, layers: [
					Layer(image: png("person")!, visible: true, scale: 0.5, rotation: 0, opacity: 1.0, top: 0, left: 0)
					])
				])
		)

		cards.append(GenerateCard("Merry Christmas!"))

		return cards
	}

	///
	/// Generates a generic card with some dummy data
	///
	class func GenerateCard(title:String) -> Card
	{
		var scenes: [Scene] = []

		scenes.append(GenerateScene("The cat's in the cradle with the silver spoon"))
		scenes.append(GenerateScene("Little boy blue and the man in the moon"))
		scenes.append(GenerateScene("When you coming home dad"))
		scenes.append(GenerateScene("I don't know when, but we'll get together then"))

		return Card(title: title, isNew: true, scenes: scenes)
	}

	///
	/// Generates a scene with some dummy data
	///
	class func GenerateScene(caption: String) -> Scene
	{
		return Scene(caption: caption, backgroundColor: nil, foregroundColor: nil, layers: [])
	}

	private class func png(basename: String) -> String?
	{
		return NSBundle.mainBundle().pathForResource(basename, ofType: ".png", inDirectory: "sprites")
	}
}
