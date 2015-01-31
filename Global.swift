//
//  Global.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-01-31.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation

var world = World ()
var game = GameScene ()

func randomInt (range:Int) -> Int {
	return random () % range
}
func randomInt (from:Int, to:Int) -> Int {
	return Int(random () % (to - from)) + from
}