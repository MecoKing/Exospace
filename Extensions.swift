//
//  Extensions.swift
//  Exoplanet
//
//  Created by [pixelmonster] on 2014-12-28.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

extension CGPoint {
	//Converts a  Cartesian point directly to Isometric
	func toIsometric () -> CGPoint {
		return CGPoint(x: x - y, y: (x + y) / 2);
	}
	//Converts a Cartesian point to an Isometric point scaled for the game
	func toUsefulIsometric () -> CGPoint {
		let isoPt = toIsometric();
		return CGPoint(x: (isoPt.x + 10.75) * 48, y: (isoPt.y + 2.5) * 48)
	}
	//Converts a Isometric point to Cartesian
	func toCartesian () -> CGPoint {
		let isoPt = fromUsefulIsometric();
		return CGPoint(x: Int(((2 * isoPt.y) + isoPt.x) / 2), y: Int((2 * isoPt.y - isoPt.x) / 2))
	}
	//Converts a useful Isometric point to Cartesian
	func fromUsefulIsometric () -> CGPoint {
		return CGPoint(x: (x / 48) - 10.75, y: (y / 48) - 2.5)
	}
	//Calculates the distance from this point to another
	func distanceFrom (pt:CGPoint) -> Int {
		var xDist = (pt.x - x) * (pt.x - x)
		var yDist = (pt.y - y) * (pt.y - y)
		var xPlusY = xDist + yDist
		return Int(sqrt(xPlusY))
	}
}