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
	
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
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
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self).toCartesian()
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
	
	override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
		for touch: AnyObject in touches {
			let location = touch.locationInNode(self).toCartesian()
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
	
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
