//
//  Stack.swift
//  Exospace
//
//  Created by [pixelmonster] on 2014-12-31.
//  Copyright (c) 2014 antitypical. All rights reserved.
//

import Foundation

struct Stack<AnyObject> {
	var items = [AnyObject]()
	var topItem: AnyObject? {
		return items.isEmpty ? nil : items[items.count - 1]
	}
	
	mutating func push(item: AnyObject) {
		items.append(item)
	}
	
	mutating func pop() -> AnyObject {
		return items.removeLast()
	}
}