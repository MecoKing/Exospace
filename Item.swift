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
		super.init(texture: image, color: SKColor.clearColor(), size: CGSize(width: 24, height: 24))
		xScale = 1
		yScale = 1
		texture?.filteringMode = SKTextureFilteringMode.Nearest
		position.y += CGFloat(6 + heightOffset)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	class func randomItem (atIndex:Int) -> Item {
		let path = NSBundle.mainBundle().pathForResource("Items", ofType: "plist")
		let availableItems:Array<Array<String>> = NSArray(contentsOfFile: path!) as Array<Array<String>>
		let itemIndex = Int(rand()) % availableItems.count
		let stackItem = (availableItems [itemIndex][1] == "YES") ? true : false
		return Item(spriteName: availableItems [itemIndex][0], heightOffset:(atIndex * 12), stackable: stackItem)
	}
}