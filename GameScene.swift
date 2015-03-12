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
	var firstScreenLocation = CGPoint(x: 0, y:0)
	var firstAnchor = CGPoint(x: 0, y: 0);
	var selectedObject: SKSpriteNode?
	var UINode = SKNode()
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
		anchorPoint = CGPoint(x: 0.5, y: 0.2)
		
		UINode.zPosition = 500
		UINode.position = CGPoint(x: (-anchorPoint.x)*size.width, y: (-anchorPoint.y)*size.height)
		addChild(UINode)
		
		addChild(world)
		world.generateMap()
		
		for button in UIButtons {
			UINode.addChild(button)
		}
		chatLabel.text = "Welcome to Exospace"
		chatLabel.fontColor = SKColor.yellowColor()
		chatLabel.fontSize = 24
		chatLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 128)
		UINode.addChild(chatLabel)
    }
	
	//----------------------------------------------------------------
	
	//Select the tile you touched
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let cartLocation = touch.locationInNode(self).toCartesian()
			let UILocation = touch.locationInNode(UINode)
			let screenLocation = touch.locationInView(self.view)
	
			for button in UIButtons {
				if button.frame.contains(UILocation) {
					button.select()
					button.runAction()
					for otherButton in UIButtons {
						if otherButton.selected && button !== otherButton { otherButton.deselect() }
					}
				}
			}

			firstSelect = cartLocation
			firstScreenLocation = screenLocation
			firstAnchor = anchorPoint;
			if !(state == "moveMap") {
				for tile in world.map {
					if tile.highlighted { tile.highlight() }
					if cartLocation == tile.cartesianPoint { tile.highlight() }
				}
			}
        }
    }
	
	//Select all the tiles in a rectangle from where you first touched to where you are touching
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
		for touch: AnyObject in touches {
			let cartLocation = touch.locationInNode(self).toCartesian()
			let screenLocation = touch.locationInView(self.view)
			if !(/*state == "removeItems" ||*/ state == "addPeople" || state == "selection" || state == "moveMap") {
				for tile in world.map {
					if tile.highlighted { tile.highlight() }
					var minX = (cartLocation.x < firstSelect.x) ? cartLocation.x : firstSelect.x
					var maxX = (cartLocation.x > firstSelect.x) ? cartLocation.x : firstSelect.x
					var minY = (cartLocation.y < firstSelect.y) ? cartLocation.y : firstSelect.y
					var maxY = (cartLocation.y > firstSelect.y) ? cartLocation.y : firstSelect.y
					if tile.cartesianPoint.x >= minX && tile.cartesianPoint.x <= maxX {
						if tile.cartesianPoint.y >= minY && tile.cartesianPoint.y <= maxY {
							tile.highlight()
						}
					}
				
				}
			}
			else if state == "moveMap" {
				let mapOffset = CGPoint(
					x: firstAnchor.x - (abs(firstScreenLocation.x)/size.width),
					y: firstAnchor.y + (abs(firstScreenLocation.y)/size.height))
				let screenX = (abs(screenLocation.x)/size.width) + mapOffset.x
				let screenY = -(abs(screenLocation.y)/size.height) + mapOffset.y
				anchorPoint = CGPoint(x: screenX, y: screenY)
				UINode.position = CGPoint(x: (-anchorPoint.x)*size.width, y: (-anchorPoint.y)*size.height)
			}
			else {
				for tile in world.map {
					if tile.highlighted { tile.highlight() }
					if cartLocation == tile.cartesianPoint { tile.highlight() }
				}
			}
		}
	}
	
	//When touches are released, do something with the selected tiles
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self).toCartesian()
			
			for tile in world.map {
				if tile.highlighted {
					if state == "addPeople" { world.placePersonAtTile(tile) }
					else if state == "addItems" { world.placeItemOnTile(tile) }
					else if state == "removeItems" { world.removeAtTile(tile) }
					else if state == "selection" && selectedObject == nil {
						if world.tileAtCartesian(location).occupied {
							for person in world.population {
								if tile.cartesianPoint == person.cartesianPoint {
									selectedObject = person
									break
								}
							}
							if selectedObject == nil {
								for stack in world.itemStacks {
									if tile.cartesianPoint == stack.cartesianPoint {
										selectedObject = stack.topItem
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
								//Set task to move item to that point
							}
						}
						selectedObject = nil
					}
					tile.highlight()
				}
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
				human.runState ()
			}
		}
		if timerTick - chatLabelTrigger >= 100 { chatLabel.runAction(SKAction.fadeAlphaBy(-1, duration: 2)) }
    }
}
