//
//  World.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-01-24.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

class World : SKNode {
	
	var map = Array<Tile> ()
	
	override init () {
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func generateMap () {
		removeAllChildren()
		for var x = 0; x < 12; x++ {
			for var y = 0; y < 12; y++ {
				let groundTile = Tile(atPoint: CGPoint(x: x, y: y), spriteName: "Grass")
				map.append(groundTile)
				groundTile.zPosition = CGFloat(24 - CGFloat(x + y))
				addChild(groundTile)
			}
		}
	}
	
	func tileAtCartesian (pt:CGPoint) -> Tile {
		for tile in map {
			if tile.cartesianPoint == pt {
				return tile
			}
		}
		return Tile(atPoint: CGPoint(), spriteName: "Grass")
	}
	
	
	class func randomInt (range:Int) -> Int {
		return random () % range
	}
	class func randomInt (start:Int, end:Int) -> Int {
		return Int(random () % end) + start
	}
	
}