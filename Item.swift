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
	var cartesianPoint:CGPoint
	
	//----------------------------------------------------------------
	
	init (atPoint:CGPoint, spriteName:String, stackable:Bool) {
		let image = SKTexture(imageNamed: spriteName)
		isStackable = stackable
		cartesianPoint = atPoint
		super.init(texture: image, color: SKColor.clearColor(), size: CGSize(width: 24, height: 24))
		xScale = 4
		yScale = 4
		texture?.filteringMode = SKTextureFilteringMode.Nearest
		position = cartesianPoint.toUsefulIsometric()
		position.y += 24
		updateZPosition()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	//Create a random Item
	class func randomItemAtPoint (pt:CGPoint) -> Item {
		let path = NSBundle.mainBundle().pathForResource("Items", ofType: "plist")
		let availableItems:Array<Dictionary<String, String>> = NSArray(contentsOfFile: path!) as Array<Dictionary<String, String>>
		let itemIndex = World.randomInt(availableItems.count)
		let stackItem = (availableItems [itemIndex]["stackable"] == "YES") ? true : false
		let newItem = Item(atPoint:pt, spriteName: availableItems [itemIndex]["imageName"]!, stackable: stackItem)
		return newItem
	}
	
	//----------------------------------------------------------------
	
	func updateZPosition () {
		zPosition = 48 - (cartesianPoint.x + cartesianPoint.y)
	}
	
}