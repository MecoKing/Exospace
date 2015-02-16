//
//  HarvestTask.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-02-16.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

public struct HarvestTask : Task {
	public var claimed = false
	public var completed:Bool {
		for stack in world.itemStacks {
			if stack.cartesianPoint == location {
				for item in stack.items {
					if item == object {
						return false
					}
				}
			}
		}
		return true
	}
	
	public let location:CGPoint
	public let object:Item
	
	public init (loc:CGPoint, obj:Item) {
		location = loc
		object = obj
	}
	
}