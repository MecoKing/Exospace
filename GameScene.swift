//
//  GameScene.swift
//  Exospace
//
//  Created by [pixelmonster] on 2014-12-30.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	var firstSelect = CGPoint(x: 0, y: 0)
	var selectedObject: SKSpriteNode?
	var timerTick = 0
	var state = "noAction"
	var chatLabel = SKLabelNode(fontNamed: "Copperplate")
	var chatLabelTrigger = 0
	
	let UIButtons = [
		Button(buttonName: "diceRollButton", index: 0),
		Button(buttonName: "moveButton", index: 1),
		Button(buttonName: "spawnButton", index: 2),
		Button(buttonName: "itemButton", index: 3),
		Button(buttonName: "deleteButton", index: 4),
	]
	
	//----------------------------------------------------------------
	
    override func didMoveToView(view: SKView) {
		game = self
		backgroundColor = SKColor(red: 0.1, green: 0, blue: 0.3, alpha: 1.0)
		
		addChild(world)
		world.generateMap()
		
		for button in UIButtons {
			button.zPosition = 256
			addChild(button)
		}
		chatLabel.zPosition = 256
		chatLabel.text = "Welcome to Exospace"
		chatLabel.fontColor = SKColor.yellowColor()
		chatLabel.fontSize = 24
		chatLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 128)
		addChild(chatLabel)
    }
	
	//----------------------------------------------------------------
	
	//Select the tile you touched
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self).toCartesian()
			let screenLocation = touch.locationInNode(self)
	
			for button in UIButtons {
				if button.frame.contains(screenLocation) {
					button.select()
					button.runAction()
					for otherButton in UIButtons {
						if otherButton.selected && button !== otherButton { otherButton.deselect() }
					}
				}
			}

			firstSelect = location
			for tile in world.map {
				if tile.highlighted { tile.highlight() }
				if location == tile.cartesianPoint { tile.highlight() }
			}
        }
    }
	
	//Select all the tiles in a rectangle from where you first touched to where you are touching
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self).toCartesian()
			let screenLocation = touch.locationInNode (self)
			if !(state == "removeItems" || state == "addPeople" || state == "selection") {
				for tile in world.map {
					if tile.highlighted {
						tile.highlight()
					}
					var minX = (location.x < firstSelect.x) ? location.x : firstSelect.x
					var maxX = (location.x > firstSelect.x) ? location.x : firstSelect.x
					var minY = (location.y < firstSelect.y) ? location.y : firstSelect.y
					var maxY = (location.y > firstSelect.y) ? location.y : firstSelect.y
					if tile.cartesianPoint.x >= minX && tile.cartesianPoint.x <= maxX {
						if tile.cartesianPoint.y >= minY && tile.cartesianPoint.y <= maxY {
							tile.highlight()
						}
					}
				
				}
			}
			else {
				for tile in world.map {
					if tile.highlighted { tile.highlight() }
					if location == tile.cartesianPoint { tile.highlight() }
				}
			}
		}
	}
	
	//When touches are released, do something with the selected tiles
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self).toCartesian()
			
			if state == "addPeople" { world.placePeople() }
			else if state == "addItems" { world.placeItems() }
			else if state == "removeItems" { world.removeThings() }
			else if state == "selection" && selectedObject == nil {
				if world.tileAtCartesian(location).occupied {
					for stack in world.itemStacks {
						if world.tileAtCartesian(location) == world.tileAtCartesian(stack.cartesianPoint) {
							selectedObject = stack.topItem
							break
						}
					}
					if selectedObject == nil {
						for person in world.population {
							if world.tileAtCartesian(location) == world.tileAtCartesian(person.cartesianPoint) {
								selectedObject = person
								break
							}
						}
					}
				}
			}
			else if state == "selection" {
				if selectedObject is Person {
					for person in world.population {
						if person == selectedObject {
							person.destination = location
							if person.state == "idle" { person.pathFind () }
						}
					}
				}
				else if selectedObject is Item {
					for item in world.itemStacks {
						//Set job to move item to that point
					}
				}
				selectedObject = nil
			}
			
			for tile in world.map {
				if tile.highlighted { tile.highlight() }
			}
		}
	}

	//----------------------------------------------------------------
	
	//Run the Game Logic
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
		timerTick++
		if timerTick % 5 == 0 {
			for human in world.population {
				human.runAI ()
			}
		}
		if timerTick - chatLabelTrigger >= 100 { chatLabel.runAction(SKAction.fadeAlphaBy(-0.01, duration: 5)) }
    }
}
