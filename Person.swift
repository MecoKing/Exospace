//
//  Person.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-01-05.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

class Person : SKSpriteNode {
	var cartesianPoint:CGPoint
	var animFrame:CGRect
	var state = "idle"
	
	init(atPoint:CGPoint, spriteName:String) {
		animFrame = CGRect(x: 0, y: 0, width: 0.25, height: 1)
		let image = SKTexture(rect: animFrame, inTexture: SKTexture(imageNamed: spriteName))
		cartesianPoint = atPoint
		super.init(texture: image, color: SKColor.clearColor(), size: CGSize(width: 24, height: 32))
		name = spriteName
		xScale = 4
		yScale = 4
		texture?.filteringMode = SKTextureFilteringMode.Nearest
		position = cartesianPoint.toUsefulIsometric()
		position.y += 44
		zPosition = 100
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	class func randomPersonAtPoint (pt:CGPoint) -> Person {
		let path = NSBundle.mainBundle().pathForResource("People", ofType: "plist")
		let people:Array<String> = NSArray(contentsOfFile: path!) as Array<String>
		let index = Int(rand()) % people.count
		return Person(atPoint: pt, spriteName: people [index])
	}
	
	func randomDestination () -> CGPoint {
		let moveDirection = random() % 2
		let moveDistance = CGFloat((random() % 4) - 2)
		let xMove = (moveDirection == 0) ? cartesianPoint.x + moveDistance : cartesianPoint.x
		let yMove = (moveDirection == 1) ? cartesianPoint.y + moveDistance : cartesianPoint.y
		return CGPoint(x: xMove, y: yMove)
	}
	
	func animate () {
		animFrame.origin.x += 0.25
		if animFrame.origin.x >= 1 {
			animFrame.origin.x = 0
		}
		texture = SKTexture(rect: animFrame, inTexture: SKTexture(imageNamed: name!))
	}
	
	func moveTo (cartesian:CGPoint) {
		state = "walking"
		let isoLocation = CGPoint(x: cartesian.toUsefulIsometric().x, y: cartesian.toUsefulIsometric().y + 44)
		let moveTime = position.distanceFrom(isoLocation) / 24
		runAction(SKAction .moveTo(isoLocation, duration: NSTimeInterval(moveTime))) {
			self.cartesianPoint = cartesian
			self.state = "idle"
		}
	}
}