//
//  GameScene.swift
//  Exospace
//
//  Created by [pixelmonster] on 2014-12-30.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import SpriteKit

var world = World ()
var game = GameScene ()

class GameScene: SKScene {
	
	var population = Array<Person> ()
	var itemses = Array<Item> ()
	var firstSelect = CGPoint(x: 0, y: 0)
	var timerTick = 0
	
	let UIButtons = [
		Button(buttonName: "diceRollButton", index: 0),
		Button(buttonName: "buildButton", index: 1)
	]
	
	//----------------------------------------------------------------
	
    override func didMoveToView(view: SKView) {
		game = self
		backgroundColor = SKColor(red: 0.1, green: 0, blue: 0.3, alpha: 1.0)
		addChild(world)
		world.generateMap()
		generateItems()
		for button in UIButtons {
			addChild(button)
		}
    }
	
	//----------------------------------------------------------------
	
	//Select the tile you touched
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self).toCartesian()
			let screenLocation = touch.locationInNode(self)
	
			for button in UIButtons {
				if button.frame.contains(screenLocation) {
					button.runAction()
				}
			}

			firstSelect = location
			var tileSelected = false
			for tile in world.map {
				if tile.highlighted {
					tile.highlight()
				}
				if location == tile.cartesianPoint {
					tile.highlight()
					tileSelected = true
				}
			}
        }
    }
	
	//Select all the tiles in a rectangle from where you first touched to where you are touching
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self).toCartesian()
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
						if !tile.occupied { tile.highlight() }
					}
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
					tile.highlight()
					if !tile.occupied {
						tile.occupied = true
						let bias = (world.tileType == "Grass") ? "human" : (world.tileType == "Magma") ? "argonian" : "none"
						let human = Person.randomPersonAtPoint(tile.cartesianPoint, world:world, speciesBias: bias)
						population.append(human)
						addChild(human)
					}
				}
			}
		}
	}
	
	//----------------------------------------------------------------
	
	//Make a random destination and send a person there
	func giveDestinationTo (human:Person) {
		let destination = human.randomDestination()
		if destination.x >= 0 && destination.x <= 11 && destination.y >= 0 && destination.y <= 11 {
			if !world.tileAtCartesian(destination).occupied {
				human.destination = destination
				human.pathFind()
			}
		}
	}
	
	//Generate random items all over the map
	func generateItems () {
		for item in itemses {
			item.removeFromParent()
		}
		itemses.removeAll(keepCapacity: false)
		
		for i in 0..<World.randomInt(12, to: 16) {
			var itemPoint = CGPoint(x:World.randomInt(0, to: 12), y:World.randomInt(0, to: 12))
			while !world.tileAtCartesian(itemPoint).occupied {
				itemPoint = (world.tileAtCartesian(itemPoint).occupied) ? CGPoint(x:World.randomInt(0, to: 12), y:World.randomInt(0, to: 12)) : itemPoint
				let rndmItem = Item.randomItemAtPoint(itemPoint, forBiome: world.tileType)
				world.tileAtCartesian(rndmItem.cartesianPoint).occupied = true
				itemses.append(rndmItem)
				addChild(rndmItem)
			}
		}
		for human in population {
			human.removeFromParent()
		}
		population.removeAll(keepCapacity: false)
	}
	
	//----------------------------------------------------------------
	
	//Run the Game Logic
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
		timerTick++
		if timerTick % 5 == 0 {
			for human in population {
				if human.state == "idle" { giveDestinationTo(human) }
				human.updateZPosition ()
				human.animate()
			}
		}
    }
}
