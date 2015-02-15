//
//  Global.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-01-31.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation

//RESOURCES
let allJobs = NSArray (contentsOfFile: NSBundle.mainBundle().pathForResource("Jobs", ofType: "plist")!) as Array<Dictionary<String, String>>
let chatOptions = NSDictionary (contentsOfFile: NSBundle.mainBundle().pathForResource("Chat", ofType: "plist")!) as Dictionary<String, Array<String>>
let biomeData = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Biomes", ofType: "plist")!) as Dictionary<String, Dictionary<String, Array<String>>>
let allItems = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Items", ofType: "plist")!) as Dictionary<String, Dictionary<String, String>>

//PROPERTIES
var world = World ()
var game = GameScene ()
var worldSize = 8


//FUNCTIONS
func randomInt (range:Int) -> Int {
	return random () % range
}
func randomInt (from:Int, to:Int) -> Int {
	return Int(random () % (to - from)) + from
}