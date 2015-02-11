//
//  Item.swift
//  Exospace
//
//  Created by [pixelmonster] on 2014-12-31.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import Foundation
import SpriteKit
import SceneKit

public class Item : SKSpriteNode {
	var isStackable:Bool
	var isTraversable:Bool
	var isCraftable:Bool
	var cartesianPoint:CGPoint
	
	//----------------------------------------------------------------
	
	init (itemID:String, atPoint pt:CGPoint) {
		let path = NSBundle.mainBundle().pathForResource("Items", ofType: "plist")
		let availableItems:Dictionary<String, Dictionary<String, String>> = NSDictionary(contentsOfFile: path!) as Dictionary<String, Dictionary<String, String>>
		let spriteName = availableItems [itemID]! ["spriteName"]
		isStackable = (availableItems [itemID]! ["stackable"] == "YES") ? true : false
		isTraversable = (availableItems [itemID]! ["traversable"] == "YES") ? true : false
		isCraftable = (availableItems [itemID]! ["craftable"] == "YES") ? true : false
		let effect = availableItems [itemID]! ["effect"]
		cartesianPoint = pt
		super.init(texture: SKTexture(imageNamed: spriteName!), color: SKColor.clearColor(), size: CGSize(width: 24, height: 24))
		name = itemID
		xScale = 4
		yScale = 4
		texture?.filteringMode = SKTextureFilteringMode.Nearest
		position = cartesianPoint.toUsefulIsometric()
		position.y += 24
		zPosition = 48 - (cartesianPoint.x + cartesianPoint.y)
		if effect != "None" {
			let particles = SKEmitterNode(fileNamed: effect!)
			particles.zPosition = 1
			particles.position.y = -6
			particles.particleTexture?.filteringMode = SKTextureFilteringMode.Nearest
			addChild(particles)
		}
	}

	required public init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	//----------------------------------------------------------------
	
	func updateZPosition () {
		zPosition = 48 - (cartesianPoint.x + cartesianPoint.y)
	}
	
}