//
//  GameScene.swift
//  Exospace
//
//  Created by [pixelmonster] on 2014-12-30.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
	
	var world = Array<Tile> ()
	var firstSelect = CGPoint(x: 0, y: 0)
	
    override func didMoveToView(view: SKView) {
		backgroundColor = SKColor(red: 0.1, green: 0, blue: 0.3, alpha: 1.0)
		for var x = 0; x < 16; x++ {
			for var y = 0; y < 16; y++ {
				let groundTile = Tile(atPoint: CGPoint(x: x, y: y), spriteName: "Grass")
				world.append(groundTile)
				addChild(groundTile)
			}
		}
		for tile in world {
			tile.zPosition = 0
			for othertile in world {
				if tile.position.y < othertile.position.y {
					tile.zPosition += 1
				}
			}
		}
    }
	
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self).toCartesian()
			firstSelect = location
			for tile in world {
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
			for tile in world {
				if tile.highlighted {
					tile.highlight()
				}
			}
		}
	}
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self).toCartesian()
			for tile in world {
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
	
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
