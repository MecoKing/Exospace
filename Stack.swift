//
//  Stack.swift
//  Exospace
//
//  Created by [pixelmonster] on 2014-12-31.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import Foundation

public struct Stack<AnyObject> {
	public init() {}
	
	var items = [AnyObject]()
	public var topItem: AnyObject? {
		return items.isEmpty ? nil : items[items.count - 1]
	}
	
	public mutating func push(item: AnyObject) {
		items.append(item)
	}
	
	public mutating func pop() -> AnyObject {
		return items.removeLast()
	}
}