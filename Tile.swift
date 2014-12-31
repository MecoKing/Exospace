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
	
	init (atPoint:CGPoint, spriteName:NSString) {
		cartesianPoint = atPoint
		let spriteFrame = CGRect(x: CGFloat (rand() % 4)/4, y: 0, width: 0.25, height: 1)
		sprite = SKSpriteNode(texture: SKTexture(rect: spriteFrame, inTexture: SKTexture(imageNamed: spriteName)))
		sprite.xScale = 3
		sprite.yScale = 3
		sprite.texture?.filteringMode = SKTextureFilteringMode.Nearest
		items = Stack<Item> ()
		super.init ()
		if Int(rand() % 10) == 0 {
			stackItemFromList(0, chance: 10)
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
		sprite.color = (items.topItem? == nil) ? SKColor.clearColor() : SKColor.greenColor()
		sprite.colorBlendFactor = (highlighted) ? 0.4 : 0
		addChild(sprite)
	}
	
	func stackItemFromList (index:Int, chance:Int) {
		let path = NSBundle.mainBundle().pathForResource("Items", ofType: "plist")
		let stringsFromPList = NSArray(contentsOfFile: path!)
		var availableItems:Array<String> = stringsFromPList as Array<String>
		
		let itemIndex = Int(rand()) % (availableItems.count - 1)
		let randomItem = Item (spriteName: availableItems [itemIndex], heightOffset:(index * 48))
		items.push(randomItem)
		addChild(randomItem)
		if Int(rand()) % chance * 2 == 0 {
			stackItemFromList(index + 1, chance: chance * 2)
		}
	}
}