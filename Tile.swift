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
	var items:Stack<Item>
	
	init (atPoint:CGPoint, spriteName:NSString) {
		cartesianPoint = atPoint
		let spriteFrame = CGRect(x: CGFloat (rand() % 4)/4, y: 0, width: 0.25, height: 1)
		let image = SKTexture(rect: spriteFrame, inTexture: SKTexture(imageNamed: spriteName))
		items = Stack<Item> ()
		super.init(texture: image, color: SKColor.clearColor(), size: CGSize(width: 32, height: 16))
		xScale = 3
		yScale = 3
		texture?.filteringMode = SKTextureFilteringMode.Nearest
		color = SKColor.clearColor()
		if Int(rand() % 10) == 0 {
			stackItemFromList(0, chance: 10)
		}
		position = cartesianPoint.toUsefulIsometric()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func highlight () {
		highlighted = (highlighted) ? false : true
		colorBlendFactor = (highlighted) ? 0.4 : 0
	}
	
	func stackItemFromList (index:Int, chance:Int) {
		let path = NSBundle.mainBundle().pathForResource("Items", ofType: "plist")
		let stringsFromPList = NSArray(contentsOfFile: path!)
		var availableItems:Array<String> = stringsFromPList as Array<String>
		
		let itemIndex = Int(rand()) % (availableItems.count - 1)
		let randomItem = Item (spriteName: availableItems [itemIndex], heightOffset:(index * 16))
		items.push(randomItem)
		addChild(randomItem)
		if Int(rand()) % chance * 2 == 0 {
			stackItemFromList(index + 1, chance: chance * 2)
		}
	}
}