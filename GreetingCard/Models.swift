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
	var visible:  Bool
	var scale:    Float
	var rotation: Int
	var opacity:  Float
	var top:      Int
	var left:     Int
	
	///
	/// Constructor
	///
	init(image:String, visible:Bool, scale:Float, rotation:Int, opacity:Float, top:Int, left:Int)
	{
		self.image = image
		self.visible = visible
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
	var caption:         String
	var layers:          [Layer]
	
	///
	/// Constructor
	///
	init(caption:String?, layers:[Layer]?)
	{
		self.caption = caption ?? ""
		self.layers = layers ?? []
	}
	
	var description : String {
		return "<Scene '\(caption)'>"
	}
}

class Card : Printable
{
	var title:  String
	var isNew:  Bool
	var scenes: [Scene]
	
	///
	/// Constructor
	///
	init(title:String?, isNew:Bool, scenes:[Scene]?)
	{
		self.title = title ?? ""
		self.isNew = isNew
		self.scenes = scenes ?? []
	}
	
	var description : String {
		return "<Card\n\ttitle='\(title)'\n\tscenes=\(scenes)>"
	}
}
