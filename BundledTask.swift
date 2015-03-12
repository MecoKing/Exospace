//
//  BundledTask.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-02-09.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

public struct BundledTask : Task {
	public var claimed = false
	public var initialState:String {
		for task in bundle {
			if !task.completed { return task.initialState }
		}
		return "idle"
	}
	public var completed:Bool {
		for task in bundle {
			if !task.completed { return false }
		}
		return true
	}
	
	public let bundle: [Task]
	
	public init (bundl:[Task]) {
		bundle = bundl
	}
}