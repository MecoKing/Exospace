//
//  GameScene.swift
//  Exospace
//
//  Created by [pixelmonster] on 2014-12-30.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	var world = World ()
	var population = Array<Person> ()
	var firstSelect = CGPoint(x: 0, y: 0)
	var timerTick = 0
	
    override func didMoveToView(view: SKView) {
		backgroundColor = SKColor(red: 0.1, green: 0, blue: 0.3, alpha: 1.0)
		addChild(world)
		world.generateMap()
    }
	
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self).toCartesian()
			firstSelect = location
			for tile in world.map {
				if tile.highlighted {
					tile.highlight()
				}
				if location == tile.cartesianPoint {
					tile.highlight()
				}
			}
        }
    }
	
	override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self).toCartesian()
			for tile in world.map {
				if tile.highlighted {
					tile.highlight()
					if !tile.occupied {
						tile.occupied = true
						let human = Person.randomPersonAtPoint(tile.cartesianPoint)
						population.append(human)
						addChild(human)
					}
				}
			}
		}
	}
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
						tile.highlight()
					}
				}
				
			}
		}
	}
	
	func updateZPosition () {
		for human in population {
			human.zPosition = world.tileAtCartesian(human.cartesianPoint).zPosition
		}
	}
	
	func giveDestinationTo (human:Person) {
		let destination = human.randomDestination()
		if destination.x >= 0 && destination.x <= 11 && destination.y >= 0 && destination.y <= 11 {
			if !world.tileAtCartesian(destination).occupied {
				world.tileAtCartesian(human.cartesianPoint).occupied = false
				world.tileAtCartesian(destination).occupied = true
				human.moveTo(destination)
			}
		}
	}
	
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
		timerTick++
		if timerTick % 5 == 0 {
			for human in population {
				if human.state == "idle" {
					giveDestinationTo(human)
				}
				human.animate()
			}
		}
		updateZPosition();
    }
}
