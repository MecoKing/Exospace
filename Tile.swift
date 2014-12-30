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
	
	init (atPoint:CGPoint, withImage:NSString) {
		cartesianPoint = atPoint
		sprite = SKSpriteNode (imageNamed: withImage)
		sprite.xScale = 2
		sprite.yScale = 2
		sprite.texture?.filteringMode = SKTextureFilteringMode.Nearest
		super.init ()
		position = cartesianPoint.toUsefulIsometric()
		addChild(sprite);
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}