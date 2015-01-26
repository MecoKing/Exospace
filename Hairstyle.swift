//
//  Hairstyle.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-01-26.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

class Hairstyle : SKSpriteNode {
	var animFrame: CGRect;
	
	init(spriteName:String) {
		animFrame = CGRect(x: 0, y: 0, width: 0.25, height: 0.25)
		let image = SKTexture(rect: animFrame, inTexture: SKTexture(imageNamed: spriteName))
		super.init(texture: image, color: SKColor.clearColor(), size: CGSize(width: 24, height: 24))
		name = spriteName
		zPosition = 10
		texture?.filteringMode = SKTextureFilteringMode.Nearest
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	//Animate according to the given frame
	func animateWithFrame (newFrame:CGRect, outfitHasHat:Bool) {
		animFrame = (!outfitHasHat) ? newFrame : CGRect(x: 0, y: 0, width: 0, height: 0)
		texture = SKTexture(rect: animFrame, inTexture: SKTexture(imageNamed: name!))
	}
	
	//Get a random hair name
	class func randomHair () -> String {
		return "RANDOM" //Decided via lots of science and math and magic and things
						//Guaranteed to be RANDOM every time!
	}
}