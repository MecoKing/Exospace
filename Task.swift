//
//  Task.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-02-09.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation

public protocol Task {
	var claimed:Bool {get set}
	var completed:Bool {get}
}