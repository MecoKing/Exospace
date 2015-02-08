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
	var immediateDestination:CGPoint
	var fullName = "Person"
	
	var state = "idle"
	var facingFore = true
	
	//----------------------------------------------------------------
	
	init(atPoint:CGPoint, species:String, genderName:String) {
		animFrame = CGRect(x: 0, y: 0, width: 0.25, height: 0.25)
		gender = genderName
		cartesianPoint = atPoint
		destination = cartesianPoint
		immediateDestination = cartesianPoint
		clothes = Outfit.randomOutfitForGender(gender)
		hairdo = Hairstyle(species:species, gender:gender)
		fullName = Person.randomName(species, genderName: gender)
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
	init(atPoint:CGPoint, species:String, jobName:String) {
		animFrame = CGRect(x: 0, y: 0, width: 0.25, height: 0.25)
		gender = (randomInt(2) == 0) ? "Male" : "Female"
		cartesianPoint = atPoint
		destination = cartesianPoint
		immediateDestination = cartesianPoint
		clothes = Outfit(spriteName: jobName, gender: gender)
		hairdo = Hairstyle(species:species, gender:gender)
		fullName = Person.randomName(species, genderName: gender)
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
		let index = (speciesBias != "none") ? randomInt(allSpecies.count + 3) : randomInt(allSpecies.count)
		let species = (index >= allSpecies.count) ? speciesBias : allSpecies [index]
		let gender = (randomInt(2) == 0) ? "Male" : "Female"
		return Person(atPoint: pt, species: species, genderName: gender)
	}
	
	//Get a random name from Names.plist
	class func randomName (speciesName:String, genderName:String) -> String {
		let path = NSBundle.mainBundle().pathForResource("Names", ofType: "plist")
		let names:Dictionary<String, Dictionary<String, Array<String>>> = NSDictionary (contentsOfFile: path!) as Dictionary<String, Dictionary<String, Array<String>>>
		let index:Int = randomInt(names [speciesName]![genderName]!.count)
		let namesForSpeciesGender = names [speciesName]![genderName]!
		return namesForSpeciesGender [index]
	}
	
	//----------------------------------------------------------------
	
	func runAI () {
		if randomInt(500) == 0 { chat() }
		else if randomInt(500) == 0 { emote("hungry") }
		else if state == "idle" && randomInt(50) == 0 { setDestination() }
		updateZPosition ()
		animate()
	}
	
	//Create a random destination
	func randomDestination () -> CGPoint {
		return CGPoint(x: randomInt(12), y: randomInt(12))
	}
	func setDestination () {
		let newDest = randomDestination()
		if newDest.x >= 0 && newDest.x <= 11 && newDest.y >= 0 && newDest.y <= 11 {
			if !world.tileAtCartesian(newDest).occupied {
				destination = newDest
				pathFind()
			}
		}
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
				if !world.tileAtCartesian(point).occupied {
					let pointF = H + (abs(point.x - destination.x) + abs(point.y - destination.y)) + 1
					if pointF < H + (abs(bestPath.x - destination.x) + abs(bestPath.y - destination.y)) + 1 {
						bestPath = point
					}
				}
			}
		}
		if bestPath == cartesianPoint { state = "idle"; println("[\(fullName)] I'm stuck!") }
		else { moveTo(bestPath) }
	}
	
	//Animate the person sprite as well as all accessories
	func animate () {
		if state != "idle" { animFrame.origin.x += 0.25 }
		else { animFrame.origin.x = 0 }
		
		if animFrame.origin.x >= 1 { animFrame.origin.x = 0 }
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
		world.tileAtCartesian(cartesianPoint).occupied = false
		world.tileAtCartesian(cartesian).occupied = true
		immediateDestination = cartesian
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
	
	func chat () {
		let chatTypes = ["Environmental", "Complaints", "Social"]
		let chatType = chatTypes [randomInt(chatTypes.count)]
		let path = NSBundle.mainBundle().pathForResource("Chat", ofType: "plist")
		let sentence:Dictionary<String, Array<String>> = NSDictionary (contentsOfFile: path!) as Dictionary<String, Array<String>>
		let index = randomInt(sentence [chatType]!.count)
		game.chatLabel.removeAllActions()
		game.chatLabel.text = ("[\(fullName)] " + sentence [chatType]![index])
		game.chatLabel.alpha = 1
		game.chatLabelTrigger = game.timerTick
		emote("speechBubble")
	}
	
	func emote (emotion:String) {
		var emoteSprite = SKSpriteNode(imageNamed: emotion)
		emoteSprite.position.y = 12
		emoteSprite.alpha = 0
		if xScale < 0 { emoteSprite.xScale = -1 }
		emoteSprite.texture?.filteringMode = SKTextureFilteringMode.Nearest
		addChild(emoteSprite)
		emoteSprite.runAction(SKAction.fadeAlphaBy(1, duration: 0.5), completion: {
			emoteSprite.runAction(SKAction.moveToY(20, duration: 2))
			emoteSprite.runAction(SKAction.fadeAlphaBy(-1, duration: 2), completion: { emoteSprite.removeFromParent() })
		})
	}
	
}