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
		hairdo = Hairstyle(spriteName: species+gender+"Hair01")
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
		let x = cartesianPoint.x, y = cartesianPoint.y, dx = destination.x, dy = destination.y
		
		if dx > x && !planet.tileAtCartesian(CGPoint(x: x + 1, y: y)).occupied {
			if dy > y  && !planet.tileAtCartesian(CGPoint(x: x, y: y + 1)).occupied {
				moveTo (CGPoint(x: x, y: y + 1))
				planet.tileAtCartesian(CGPoint(x: x, y: y + 1)).occupied = true
				planet.tileAtCartesian(cartesianPoint).occupied = false
			} else {
				moveTo (CGPoint(x: x + 1, y: y))
				planet.tileAtCartesian(CGPoint(x: x + 1, y: y)).occupied = true
				planet.tileAtCartesian(cartesianPoint).occupied = false
			}
		} else if dy > y  && !planet.tileAtCartesian(CGPoint(x: x, y: y + 1)).occupied {
			if dx < x  && !planet.tileAtCartesian(CGPoint(x: x - 1, y: y)).occupied {
				moveTo (CGPoint(x: x - 1, y: y))
				planet.tileAtCartesian(CGPoint(x: x - 1, y: y)).occupied = true
				planet.tileAtCartesian(cartesianPoint).occupied = false
			} else {
				moveTo (CGPoint(x: x, y: y + 1))
				planet.tileAtCartesian(CGPoint(x: x, y: y + 1)).occupied = true
				planet.tileAtCartesian(cartesianPoint).occupied = false
			}
		} else if dx < x  && !planet.tileAtCartesian(CGPoint(x: x - 1, y: y)).occupied {
			if dy < y  && !planet.tileAtCartesian(CGPoint(x: x, y: y - 1)).occupied {
				moveTo (CGPoint(x: x, y: y - 1))
				planet.tileAtCartesian(CGPoint(x: x, y: y - 1)).occupied = true
				planet.tileAtCartesian(cartesianPoint).occupied = false
			} else {
				moveTo (CGPoint(x: x - 1, y: y))
				planet.tileAtCartesian(CGPoint(x: x - 1, y: y)).occupied = true
				planet.tileAtCartesian(cartesianPoint).occupied = false
			}
		} else if dy < y  && !planet.tileAtCartesian(CGPoint(x: x, y: y - 1)).occupied {
			if dx > x && !planet.tileAtCartesian(CGPoint(x: x + 1, y: y)).occupied {
				moveTo (CGPoint(x: x, y: y + 1))
				planet.tileAtCartesian(CGPoint(x: x, y: y + 1)).occupied = true
				planet.tileAtCartesian(cartesianPoint).occupied = false
			} else {
				moveTo (CGPoint(x: x, y: y - 1))
				planet.tileAtCartesian(CGPoint(x: x, y: y - 1)).occupied = true
				planet.tileAtCartesian(cartesianPoint).occupied = false
			}
		} else {
			state = "idle"
		}
	}
	
	//Animate the person sprite as well as all accessories
	func animate () {
		animFrame.origin.x += 0.25
		if animFrame.origin.x >= 1 {
			animFrame.origin.x = 0
		}
		animFrame.origin.y = (state == "idle") ? 0.5 : 0.75
		animFrame.origin.y -= (facingFore) ? 0 : 0.5
		texture = SKTexture(rect: animFrame, inTexture: SKTexture(imageNamed: name!))
		clothes.animateWithFrame(animFrame)
		hairdo.animateWithFrame(animFrame, outfitHasHat: clothes.hasHair)
	}
	
	//Move me to this destination
	func moveTo (cartesian:CGPoint) {
		state = "walking"
		let isoLocation = CGPoint(x: cartesian.toUsefulIsometric().x, y: cartesian.toUsefulIsometric().y + 28)
		let moveTime = position.distanceFrom(isoLocation) / 24
		xScale = (isoLocation.x > position.x) ? 4.0 : -4.0
		facingFore = (isoLocation.y < position.y) ? true : false
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