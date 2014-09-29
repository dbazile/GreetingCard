//
//  Models.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import Foundation

struct Layer : Printable {
	var image : String
	var visible : Bool
	var scale : Float
	var rotation : Int
	var opacity : Float
	var top : Int
	var left : Int
	
	var description : String {
		return "<Layer image=\(image) xy=(\(left), \(top))>"
	}
}

struct Scene : Printable {
	var caption : String
	var layers : [Layer]
	
	var description : String {
		return "<Scene '\(caption)'>"
	}
}

struct Card : Printable {
	var title : String
	var isNew : Bool
	var scenes : [Scene]
	
	var description : String {
		return "<Card\n\ttitle='\(title)'\n\tscenes=\(scenes)>"
	}
}
