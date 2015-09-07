//
//  Tile.swift
//  Exoplanet
//
//  Created by [pixelmonster] on 2014-12-28.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

class Tile : SKSpriteNode {
	var cartesianPoint:CGPoint
	var highlighted = false
	var occupied = false
	
	//----------------------------------------------------------------
	
	override class func initialize() {
		srandomdev()
	}
	
	init (atPoint:CGPoint, spriteName:NSString) {
		cartesianPoint = atPoint
		let spriteFrame = CGRect(x: CGFloat (randomInt(4))/4, y: 0, width: 0.25, height: 1)
		let image = SKTexture(rect: spriteFrame, inTexture: SKTexture(imageNamed: spriteName as String))
		super.init(texture: image, color: SKColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.2), size: CGSize(width: 24, height: 12))
		xScale = 4
		yScale = 4
		texture?.filteringMode = SKTextureFilteringMode.Nearest
		position = cartesianPoint.toUsefulIsometric()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	//----------------------------------------------------------------
	
	//Highlight the tile (By making it transparent :P)
	func highlight () {
		highlighted = (highlighted) ? false : true
		colorBlendFactor = (highlighted) ? 0.4 : 0
	}
}