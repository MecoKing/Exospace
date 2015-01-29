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
	let selectBox = SKSpriteNode(texture: SKTexture(imageNamed: "buttonSelect"), color: SKColor.clearColor(), size: CGSize(width: 96, height: 96))
	let job:String
	
	init (buttonName:String, index:Int) {
		let jobs = ["diceRollButton":"randomWorld", "buildButton":"buildItems", "spawnButton":"spawnPeople", "itemButton":"spawnItems"]
		if jobs [buttonName] != nil { job = jobs [buttonName]! }
		else { job = "noJob" }
		selectBox.texture?.filteringMode = SKTextureFilteringMode.Nearest
		super.init(texture: SKTexture(imageNamed: buttonName), color: SKColor.clearColor(), size: CGSize(width: 96, height: 96))
		name = buttonName
		position = CGPoint(x: 48 + (96 * index), y: 144)
		texture?.filteringMode = SKTextureFilteringMode.Nearest
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func select () {
		if !selected {
			addChild(selectBox)
			selected = true
		}
	}
	func deselect () {
		removeChildrenInArray([selectBox])
		selected = false
	}
	
	func runAction () {
		switch job {
			case "randomWorld":
				game.resetWorld()
			case "spawnPeople":
				game.state = "addPeople"
			case "spawnItems":
				game.state = "addItems"
			default:
				println("Button: \(name) has no job")
		}
	}
	
}