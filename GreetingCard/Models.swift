//
//  Models.swift
//  GreetingCarder
//
//  Created by David Bazile on 9/27/14.
//  Copyright (c) 2014 David Bazile. All rights reserved.
//

import Foundation

struct Layer {
	var image: String
	var visible: Bool
	var scale: Float
	var rotation: Int32
	var opacity: Float
	var top: Int32
	var left: Int32
}

struct Scene {
	var layers: [Layer]
	var caption: String
}

struct Card {
	var scenes: [Scene]
	var title: String
	var isNew: Bool
}
