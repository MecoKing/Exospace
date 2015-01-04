//
//  Item.swift
//  Exospace
//
//  Created by [pixelmonster] on 2014-12-31.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

class Item : SKSpriteNode {
	var isStackable:Bool
	
	init (spriteName:String, heightOffset:Int, stackable:Bool) {
		let image = SKTexture(imageNamed: spriteName)
		isStackable = stackable
		super.init(texture: image, color: SKColor.clearColor(), size: CGSize(width: 32, height: 32))		
		xScale = 1
		yScale = 1
		texture?.filteringMode = SKTextureFilteringMode.Nearest
		position.y += CGFloat(8 + heightOffset)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}