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
		return CGPoint(x: (isoPt.x + 9) * 32, y: (isoPt.y + 1) * 32)
	}
	func toCartesian () -> CGPoint {
		let isoPt = fromUsefulIsometric();
		return CGPoint(x: (2 * y + x) / 2, y: (2 * y - x) / 2)
	}
	func fromUsefulIsometric () -> CGPoint {
		return CGPoint(x: (x / 32) - 9, y: (y / 32) - 1)
	}
}