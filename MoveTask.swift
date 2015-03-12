//
//  MoveTask.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-02-09.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

public struct MoveTask : Task {
	public var claimed = false
	public var completed:Bool {
		for stack in world.itemStacks {
			if stack.cartesianPoint == destination {
				for item in stack.items {
					if item == object {
						return true
					}
				}
			}
		}
		return false
	}
	public var initialState = "moveItem"
	
	public let location:CGPoint
	public let destination:CGPoint
	public let object:Item
	
	public init (loc:CGPoint, obj:Item, dest:CGPoint) {
		location = loc
		object = obj
		destination = dest
	}
	
}