//
//  ButtonManager.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-01-29.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

class Button : SKSpriteNode {
	
	var selected = false
	let job:String
	
	init (buttonName:String, index:Int) {
		let jobs = ["diceRollButton":"randomWorld", "buildButton":"buildItems"]
		if jobs [buttonName] != nil { job = jobs [buttonName]! }
		else { job = "noJob" }
		super.init(texture: SKTexture(imageNamed: buttonName), color: SKColor.clearColor(), size: CGSize(width: 96, height: 96))
		name = buttonName
		position = CGPoint(x: 48 + (96 * index), y: 144)
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func runAction () {
		switch job {
			case "randomWorld":
				world.generateMap()
				game.generateItems()
			default:
				println("Button: \(name) has no job")
		}
	}
	
}