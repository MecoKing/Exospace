//
//  Tile.swift
//  Exoplanet
//
//  Created by [pixelmonster] on 2014-12-28.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

class Tile : SKNode {
	var cartesianPoint:CGPoint
	var sprite:SKSpriteNode
	var highlighted = false
	var items:Stack<Item>
	
	init (atPoint:CGPoint, withImage:NSString) {
		cartesianPoint = atPoint
		sprite = SKSpriteNode (imageNamed: withImage)
		sprite.xScale = 3
		sprite.yScale = 3
		sprite.texture?.filteringMode = SKTextureFilteringMode.Nearest
		items = Stack<Item> ()
		super.init ()
		if Int(rand() % 5) == 0 {
			stackItemFromList()
		}
		position = cartesianPoint.toUsefulIsometric()
		addChild(sprite);
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func highlight () {
		sprite.removeFromParent()
		highlighted = (highlighted) ? false : true
		sprite.color = SKColor.greenColor()
		sprite.colorBlendFactor = (highlighted) ? 1 : 0
		addChild(sprite)
	}
}