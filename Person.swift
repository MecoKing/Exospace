//
//  Person.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-01-05.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

class Person : SKSpriteNode {
	var cartesianPoint:CGPoint
	var animFrame:CGRect
	var clothes:Outfit
	let gender:String
	var hairdo:Hairstyle
	var destination:CGPoint
	
	var planet:World// REMOVE WHEN CLASS VARIABLES ARE ADDED!
	var state = "idle"
	var facingFore = true
	
	//----------------------------------------------------------------
	
	init(atPoint:CGPoint, species:String, genderName:String, inWorld:World) {
		animFrame = CGRect(x: 0, y: 0, width: 0.25, height: 0.25)
		gender = genderName
		cartesianPoint = atPoint
		destination = cartesianPoint
		clothes = Outfit.randomOutfitForGender(gender)
		hairdo = Hairstyle(species:species, gender:gender)
		planet = inWorld
		let image = SKTexture(rect: animFrame, inTexture: SKTexture(imageNamed: species + gender))
		super.init(texture: image, color: SKColor.clearColor(), size: CGSize(width: 24, height: 24))
		addChild (clothes)
		addChild(hairdo)
		name = species + gender
		xScale = 4
		yScale = 4
		texture?.filteringMode = SKTextureFilteringMode.Nearest
		position = cartesianPoint.toUsefulIsometric()
		position.y += 28
		zPosition = 100
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	//Create a random Person
	class func randomPersonAtPoint (pt:CGPoint, world:World, speciesBias:String) -> Person {
		let allSpecies = ["human", "argonian"]
		let index = (speciesBias != "none") ? World.randomInt(allSpecies.count + 3) : World.randomInt(allSpecies.count)
		let species = (index >= allSpecies.count) ? speciesBias : allSpecies [index]
		let gender = (World.randomInt(2) == 0) ? "Male" : "Female"
		return Person(atPoint: pt, species: species, genderName: gender, inWorld:world)
	}
	
	//----------------------------------------------------------------
	
	//Create a random destination
	func randomDestination () -> CGPoint {
		return CGPoint(x: World.randomInt(12), y: World.randomInt(12))
	}
	
	func updateZPosition () {
		zPosition = 48 - (cartesianPoint.x + cartesianPoint.y)
	}
	
	func pathFind () {
		let H = abs(cartesianPoint.x - destination.x) + abs(cartesianPoint.y - destination.y)
		let north = CGPoint (x: cartesianPoint.x, y: cartesianPoint.y+1)
		let east = CGPoint (x: cartesianPoint.x+1, y: cartesianPoint.y)
		let south = CGPoint (x: cartesianPoint.x, y: cartesianPoint.y-1)
		let west = CGPoint (x: cartesianPoint.x-1, y: cartesianPoint.y)
		
		var bestPath = cartesianPoint
		for point in [north, east, south, west] {
			if point.x >= 0 && point.x <= 11 && point.y >= 0 && point.y <= 11 {
				if !planet.tileAtCartesian(point).occupied {
					let pointF = H + (abs(point.x - destination.x) + abs(point.y - destination.y)) + 1
					if pointF < H + (abs(bestPath.x - destination.x) + abs(bestPath.y - destination.y)) + 1 {
						bestPath = point
					}
				}
			}
		}
		if bestPath == cartesianPoint {state = "idle"}
		else {moveTo(bestPath)}
	}
	
	//Animate the person sprite as well as all accessories
	func animate () {
		animFrame.origin.x += 0.25
		if animFrame.origin.x >= 1 {
			animFrame.origin.x = 0
		}
		animFrame.origin.y = (state == "walking") ? 0.75 : 0.5
		animFrame.origin.y -= (facingFore) ? 0 : 0.5
		texture = SKTexture(rect: animFrame, inTexture: SKTexture(imageNamed: name!))
		clothes.animateWithFrame(animFrame)
		hairdo.animateWithFrame(animFrame, outfitHasHat: clothes.hasHair)
	}
	
	//Move me to this destination
	func moveTo (cartesian:CGPoint) {
		state = "walking"
		let isoLocation = CGPoint(x: cartesian.toUsefulIsometric().x, y: cartesian.toUsefulIsometric().y + 28)
		let moveTime = position.distanceFrom(isoLocation) / 26
		xScale = (isoLocation.x > position.x) ? 4.0 : -4.0
		facingFore = (isoLocation.y < position.y) ? true : false
		planet.tileAtCartesian(cartesianPoint).occupied = false
		planet.tileAtCartesian(cartesian).occupied = true
		runAction(SKAction .moveTo(isoLocation, duration: NSTimeInterval(moveTime))) {
			self.cartesianPoint = cartesian
			if self.destination == self.cartesianPoint {
				self.state = "idle"
			}
			else {
				self.pathFind()
			}
		}
	}
}