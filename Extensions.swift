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
		return CGPoint(x: (isoPt.x + 10.75) * 48, y: (isoPt.y + 2.5) * 48)
	}
	func toCartesian () -> CGPoint {
		let isoPt = fromUsefulIsometric();
		return CGPoint(x: Int(((2 * isoPt.y) + isoPt.x) / 2), y: Int((2 * isoPt.y - isoPt.x) / 2))
	}
	func fromUsefulIsometric () -> CGPoint {
		return CGPoint(x: (x / 48) - 10.75, y: (y / 48) - 2.5)
	}
}