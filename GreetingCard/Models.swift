//
//  Models.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import Foundation

class Layer : Printable
{
	var image:    String
	var scale:    Float
	var rotation: Int
	var opacity:  Float
	var top:      Int
	var left:     Int
	
	///
	/// Constructor
	///
	init(image:String, scale:Float, rotation:Int, opacity:Float, top:Int, left:Int)
	{
		self.image = image
		self.scale = scale
		self.rotation = rotation
		self.opacity = opacity
		self.top = top
		self.left = left
	}
	
	var description : String {
		return "<Layer image=\(image) xy=(\(left), \(top))>"
	}
}

class Scene : Printable
{
	var caption: String
	var layers:  ArrayList<Layer>
	
	///
	/// Constructor
	///
	init(caption:String?, layers:[Layer]?)
	{
		self.caption = caption ?? ""
		self.layers = ArrayList(items:layers ?? [])
	}
	
	var description : String {
		return "<Scene '\(caption)'>"
	}
}

class Card : Printable
{
	var title:  String
	var isNew:  Bool
	var scenes: ArrayList<Scene>
	
	///
	/// Constructor
	///
	init(title:String?, isNew:Bool, scenes:[Scene]?)
	{
		self.title = title ?? ""
		self.isNew = isNew
		self.scenes = ArrayList(items:scenes ?? [])
	}
	
	var description : String {
		return "<Card\n\ttitle='\(title)'\n\tscenes=\(scenes)>"
	}
}

///
/// Got tired of dealing with pass-by-value arrays
///
class ArrayList<T>
{
	private var items: [T]

	///
	/// Returns a count for items in this collection
	///
	var count: Int {
		return items.count
	}
	
	///
	/// Grabs the first item in the collection, if exists
	///
	var first: T? {
		return items.count > 0 ? items[0] : nil
	}
	
	///
	/// Returns the array of items (needed because I'm too dumb to get Generators working)
	///
	var values: [T] {
		return items
	}
	
	///
	/// Constructor
	///
	init(items: [T])
	{
		self.items = items
	}
	
	///
	/// Convenience Constructor
	///
	convenience init()
	{
		self.init(items: [])
	}
	
	///
	/// Adds an item to the tail of an array
	///
	func append(item: T)
	{
		items.append(item)
	}
	
	///
	/// Inserts an element at a given index
	///
	func insert(item: T, atIndex: Int)
	{
		items.insert(item, atIndex:atIndex)
	}
	
	///
	/// Performs a map operation against a collection
	///
	func map(transform: (T) -> AnyObject!) -> [AnyObject!]
	{
		return items.map(transform)
	}
	
	///
	/// Inserts an item at the head of the array
	///
	func prepend(item: T)
	{
		items.insert(item, atIndex:0)
	}
	
	///
	/// Removes the item at a given index
	///
	func remove(index: Int)
	{
		items.removeAtIndex(index)
	}
	
	///
	/// Swaps the indices of two objects
	///
	func swap(a: Int, _ b: Int)
	{
		let currentA = items[a]
		let currentB = items[b]
		items[a] = currentB
		items[b] = currentA
	}
	
	///
	/// Enables array-style subscripting on instances this class
	///
	subscript(index: Int) -> T
	{
		return items[index]
	}
	
	///
	/// Property to assist in debugging
	///
	var description: String {
		return "\(items)"
	}
}


