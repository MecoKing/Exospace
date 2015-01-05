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
	
	override class func initialize() {
		srandomdev()
	}
	
	init (atPoint:CGPoint, spriteName:NSString) {
		cartesianPoint = atPoint
		let spriteFrame = CGRect(x: CGFloat (random() % 4)/4, y: 0, width: 0.25, height: 1)
		let image = SKTexture(rect: spriteFrame, inTexture: SKTexture(imageNamed: spriteName))
		items = Stack<Item> ()
		super.init(texture: image, color: SKColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 0.2), size: CGSize(width: 24, height: 12))
		xScale = 4
		yScale = 4
		texture?.filteringMode = SKTextureFilteringMode.Nearest
		if Int(random() % 10) == 0 {
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
		let availableItems:Array<Array<String>> = NSArray(contentsOfFile: path!) as Array<Array<String>>
		let itemIndex = Int(rand()) % (availableItems.count - 1)
		let stackItem = (availableItems [itemIndex][1] == "YES") ? true : false
		let randomItem = Item (spriteName: availableItems [itemIndex][0], heightOffset:(index * 16), stackable: stackItem)
		items.push(randomItem)
		addChild(randomItem)
		if Int(random()) % chance == 0 && stackItem {
			stackItemFromList(index + 1, chance: chance)
		}
	}
}