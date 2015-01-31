//
//  Outfit.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-01-23.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

class Outfit : SKSpriteNode {
	
	var animFrame: CGRect
	let hasHair: Bool
	
	init(spriteName:String, hasHeadpiece:Bool) {
		animFrame = CGRect(x: 0, y: 0, width: 0.25, height: 0.25)
		hasHair = hasHeadpiece
		let image = SKTexture(rect: animFrame, inTexture: SKTexture(imageNamed: spriteName))
		super.init(texture: image, color: SKColor.clearColor(), size: CGSize(width: 24, height: 24))
		name = spriteName
		zPosition = 0.1
		texture?.filteringMode = SKTextureFilteringMode.Nearest
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	//Animate according to the given frame
	func animateWithFrame (newFrame:CGRect) {
		animFrame = newFrame
		texture = SKTexture(rect: animFrame, inTexture: SKTexture(imageNamed: name!))
	}
	
	//Get a random job name
	class func randomOutfitForGender ( gender:String) -> Outfit {
		let path = NSBundle.mainBundle().pathForResource("Jobs", ofType: "plist")
		let jobs:Array<Dictionary<String, String>> = NSArray (contentsOfFile: path!) as Array<Dictionary<String, String>>
		let jobIndex = randomInt(jobs.count)
		return Outfit(
			spriteName: jobs [jobIndex]["Name"]! + gender,
			hasHeadpiece: (jobs [jobIndex]["Headpiece"]! == "YES") ? true : false
		)
	}
	
}