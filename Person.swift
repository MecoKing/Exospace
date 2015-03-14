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
	var inventory:Item?
	var currentTask:Task?
	var state = "idle"
	var facingFore = true
	
	//----------------------------------------------------------------
	
	init(atPoint:CGPoint, species:String) {
		animFrame = CGRect(x: 0, y: 0, width: 0.25, height: 0.25)
		gender = (randomInt(2) == 0) ? "Male" : "Female"
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
		updateZPosition()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	//Get a random name from Names.plist
	class func randomName (speciesName:String, genderName:String) -> String {
		let index:Int = randomInt(allNames [speciesName]![genderName]!.count)
		let namesForSpeciesGender = allNames [speciesName]![genderName]!
		return namesForSpeciesGender [index]
	}
	
	//----------------------------------------------------------------
	//STATE MACHINE
	var taskComplete:Bool { get { return currentTask?.completed ?? true } }
	var taskAvailable:Bool { get { return !world.tasks.isEmpty } }
	var hungerIsLow:Bool { get { return randomInt(500) == 0 } }
	var fatigueIsLow:Bool { get { return randomInt(500) == 0 } }
	var inventoryFull:Bool { get { return inventory != nil } }
	var atDestination:Bool { get { return destination == cartesianPoint } }
	var atNearestDestination:Bool { get { return immediateDestination == cartesianPoint } }
	
	func runState () {
		updateZPosition ()
		animate ()
		
		if state == "idle" { runIdle () }
		else if state == "getTask" { runGetTask () }
		else if state == "moveSpace" { runMoveToNearest () }
		else if state == "moveItem" { runMoveItem() }
		
	}
	func runIdle () {
		if !atNearestDestination { state = "moveSpace" }
		else if !taskComplete { state = currentTask!.initialState }
		else if hungerIsLow { emote("hungry") }
		else if fatigueIsLow { emote("tired") }
		else if randomInt(50) == 0 { setDestination() }
		else { state = "getTask" }
	}
	func runGetTask () {
		for (index, var task) in enumerate(world.tasks) {
			if !task.claimed {
				currentTask = task
				world.tasks.removeAtIndex(index);
				state = "workingTask"
				chat ("I have a purpose!")
				break
			}
		}
		if taskComplete { state = "idle" }
	}
	func runMoveToNearest () {
		state = "walking"
		let isoLocation = CGPoint(x: immediateDestination.toUsefulIsometric().x, y: immediateDestination.toUsefulIsometric().y + 28)
		let moveTime = position.distanceFrom(isoLocation) / 24
		xScale = (isoLocation.x > position.x) ? 4.0 : -4.0
		facingFore = (isoLocation.y < position.y) ? true : false
		world.tileAtCartesian(cartesianPoint).occupied = false
		world.tileAtCartesian(immediateDestination).occupied = true
		runAction(SKAction .moveTo(isoLocation, duration: NSTimeInterval(moveTime))) {
			self.cartesianPoint = self.immediateDestination
			if self.atDestination { self.state = "idle" }
			else { self.pathFind () }
		}
	}
	func runMoveItem () {//MoveItemTask stateDelegator
		let moveTask = currentTask as MoveTask
		var didSomethingUseful = false
		if inventory?.name == moveTask.object.name {
			if cartesianPoint.distanceFrom(moveTask.destination) <= 1 {
				world.placeItemOnTile(moveTask.object, tile: world.tileAtCartesian(moveTask.destination))
				inventory = nil
				didSomethingUseful = true
				state = "harvesting"
			} else {
				let adjacentTiles = [
					CGPoint(x: moveTask.destination.x + 1, y: moveTask.destination.y),
					CGPoint(x: moveTask.destination.x, y: moveTask.destination.y + 1),
					CGPoint(x: moveTask.destination.x - 1, y: moveTask.destination.y),
					CGPoint(x: moveTask.destination.x, y: moveTask.destination.y - 1)
				]
				for adjacentPoint in adjacentTiles {
					if !world.tileAtCartesian(adjacentPoint).occupied {
						destination = adjacentPoint
						pathFind()
						didSomethingUseful = true
						break
					}
				}
			}
		} else if world.containsItem(moveTask.object, atPoint: moveTask.location) {
			if (cartesianPoint.distanceFrom(moveTask.location) <= 1) {
				state = "harvesting"
				inventory = moveTask.object
				world.removeAtTile(world.tileAtCartesian(moveTask.location))
				didSomethingUseful = true
			} else {
				let adjacentTiles = [
					CGPoint(x: moveTask.location.x + 1, y: moveTask.destination.y),
					CGPoint(x: moveTask.location.x, y: moveTask.destination.y + 1),
					CGPoint(x: moveTask.location.x - 1, y: moveTask.destination.y),
					CGPoint(x: moveTask.location.x, y: moveTask.destination.y - 1)
				]
				for adjacentPoint in adjacentTiles {
					if !world.tileAtCartesian(adjacentPoint).occupied {
						destination = adjacentPoint
						pathFind()
						didSomethingUseful = true
						break
					}
				}
			}
		}
		if !didSomethingUseful {
			world.tasks.append(currentTask!)
			currentTask = nil
			state = "idle"
		}
	}
	
	//----------------------------------------------------------------
	
	//Create a random destination
	func randomDestination () -> CGPoint {
		return CGPoint(x: randomInt(12), y: randomInt(12))
	}
	func setDestination () {
		let newDest = randomDestination()
		if newDest.x >= 0 && newDest.x <= CGFloat(worldSize-1) && newDest.y >= 0 && newDest.y <= CGFloat(worldSize-1) {
			if !world.tileAtCartesian(newDest).occupied {
				destination = newDest
				pathFind()
			}
		}
	}
	
	func updateZPosition () {
		zPosition = (CGFloat(worldSize) * 4) - (cartesianPoint.x + cartesianPoint.y)
	}
	
	func pathFind () {
		let H = abs(cartesianPoint.x - destination.x) + abs(cartesianPoint.y - destination.y)
		let north = CGPoint (x: cartesianPoint.x, y: cartesianPoint.y+1)
		let east = CGPoint (x: cartesianPoint.x+1, y: cartesianPoint.y)
		let south = CGPoint (x: cartesianPoint.x, y: cartesianPoint.y-1)
		let west = CGPoint (x: cartesianPoint.x-1, y: cartesianPoint.y)
		
		var bestPath = cartesianPoint
		for point in [north, east, south, west] {
			if point.x >= 0 && point.x <= CGFloat(worldSize-1) && point.y >= 0 && point.y <= CGFloat(worldSize-1) {
				if !world.tileAtCartesian(point).occupied {
					let pointF = H + (abs(point.x - destination.x) + abs(point.y - destination.y)) + 1
					if pointF < H + (abs(bestPath.x - destination.x) + abs(bestPath.y - destination.y)) + 1 {
						bestPath = point
					}
				}
			}
		}
		if bestPath == cartesianPoint {
			state = "idle"
			destination = cartesianPoint;
			let stuckWords = ["Argh! I'm Stuck!", "When'd this get here!?", "Outta my way!", "Who put this here!"]
			chat (stuckWords [randomInt(stuckWords.count)])
		}
		else {
			immediateDestination = bestPath;
			state = "moveSpace"
		}
	}
	
	//Animate the person sprite as well as all accessories
	func animate () {
		if state == "walking" || state == "harvesting" { animFrame.origin.x += 0.25 }
		else { animFrame.origin.x = 0 }
		
		if animFrame.origin.x >= 1 { animFrame.origin.x = 0; state = (state == "harvesting") ? "idle" : state }
		animFrame.origin.y = (state == "walking") ? 0.75 : 0.5
		animFrame.origin.y -= (facingFore) ? 0 : 0.5
		texture = SKTexture(rect: animFrame, inTexture: SKTexture(imageNamed: name!))
		clothes.animateWithFrame(animFrame)
		hairdo.animateWithFrame(animFrame, outfitHasHat: clothes.hasHair)
	}
	
	func chat (sentence:String) {
		game.chatLabel.removeAllActions()
		game.chatLabel.text = ("[\(fullName)] " + sentence)
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