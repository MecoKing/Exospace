//
//  Item.swift
//  Exospace
//
//  Created by [pixelmonster] on 2014-12-31.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

class Item : SKNode {
	let sprite:SKSpriteNode
	init (spriteName:String) {
		let spriteFrame = CGRect(x: CGFloat (rand() % 4)/4, y: 0, width: 0.25, height: 1)
		sprite = SKSpriteNode(texture: SKTexture(rect: spriteFrame, inTexture: SKTexture(imageNamed: spriteName)))
		sprite.xScale = 3
		sprite.yScale = 3
		sprite.texture?.filteringMode = SKTextureFilteringMode.Nearest
		sprite.position.y += 24
		super.init()
		addChild(sprite)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
}