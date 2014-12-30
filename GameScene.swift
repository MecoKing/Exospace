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
		for var x = 0; x < 24; x++ {
			for var y = 0; y < 24; y++ {
				let groundTile = Tile(atPoint: CGPoint(x: x, y: y), withImage: "IronTile")
				world.append(groundTile)
				addChild(groundTile)
			}
		}
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
