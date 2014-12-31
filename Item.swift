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
	init (spriteName:String, heightOffset:Int) {
		let spriteFrame = CGRect(x: CGFloat (rand() % 4)/4, y: 0, width: 0.25, height: 1)
		let image = SKTexture(rect: spriteFrame, inTexture: SKTexture(imageNamed: spriteName))
		super.init(texture: image, color: SKColor.clearColor(), size: CGSize(width: 32, height: 32))		
		xScale = 3
		yScale = 3
		texture?.filteringMode = SKTextureFilteringMode.Nearest
		position.y += CGFloat(24 + heightOffset)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}