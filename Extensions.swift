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
	func toIsometric () -> CGPoint {
		return CGPoint(x: x - y, y: (x + y) / 2);
	}
	func toUsefulIsometric () -> CGPoint {
		let isoPt = toIsometric();
		return CGPoint(x: (isoPt.x + 10) * 48, y: (isoPt.y - 3) * 48)
	}
	func toCartesian () -> CGPoint {
		let isoPt = fromUsefulIsometric();
		return CGPoint(x: Int(((2 * isoPt.y) + isoPt.x) / 2), y: Int((2 * isoPt.y - isoPt.x) / 2))
	}
	func fromUsefulIsometric () -> CGPoint {
		return CGPoint(x: (x / 48) - 10, y: (y / 48) + 3)
	}
}