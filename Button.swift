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
	let selectBox = SKSpriteNode(texture: SKTexture(imageNamed: "buttonSelect"), color: SKColor.clearColor(), size: CGSize(width: 72, height: 72))
	let job:String
	
	init (buttonName:String, index:Int) {
		let jobs = [
			"diceRollButton":"randomWorld",
			"buildButton":"buildItems",
			"spawnButton":"spawnPeople",
			"itemButton":"spawnItems",
			"deleteButton":"removeItems",
			"moveButton":"selectThing"
		]
		if jobs [buttonName] != nil { job = jobs [buttonName]! }
		else { job = "noJob" }
		selectBox.zPosition = 257
		selectBox.texture?.filteringMode = SKTextureFilteringMode.Nearest
		super.init(texture: SKTexture(imageNamed: buttonName), color: SKColor.clearColor(), size: CGSize(width: 72, height: 72))
		name = buttonName
		position = CGPoint(x: 36 + (72 * index), y: 132)
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
				world.resetWorld()
			case "spawnPeople":
				game.state = "addPeople"
			case "spawnItems":
				game.state = "addItems"
			case "removeItems":
				game.state = "removeItems"
			case "selectThing":
				game.state = "selection"
			default:
				game.state = "noAction"
				println("Button: \(name) has no job")
		}
	}
	
}