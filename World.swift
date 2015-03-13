//
//  World.swift
//  Exospace
//
//  Created by [pixelmonster] on 2015-01-24.
//  Copyright (c) 2015 antitypical. All rights reserved.
//

import Foundation
import SpriteKit

class World : SKNode {
	
	var map = Array<Tile> ()
	var tileType = "Grass"
	var tasks = Array<Task> ()
	
	var population = Array<Person> ()
	var itemStacks = Array<Stack<Item>> ()
	
	//----------------------------------------------------------------
	
	override init () {
		super.init()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	//----------------------------------------------------------------
	
	//return the tile at this point
	func tileAtCartesian (pt:CGPoint) -> Tile {
		for tile in map {
			if tile.cartesianPoint == pt {
				return tile
			}
		}
		return Tile(atPoint: CGPoint(), spriteName: tileType)
	}
	
	//----------------------------------------------------------------
	
	//Generate a random map
	func generateMap () {
		removeAllChildren()
		map.removeAll(keepCapacity: false)
		
		let tileTypes = ["Terra", "Desert", "Magma", "Glacier", "Jungle", "Asteroid", "Starship"]
		tileType = tileTypes [randomInt(tileTypes.count)]
		for var x = 0; x < worldSize; x++ {
			for var y = 0; y < worldSize; y++ {
				let groundTile = Tile(atPoint: CGPoint(x: x, y: y), spriteName: tileType)
				map.append(groundTile)
				groundTile.zPosition = CGFloat((CGFloat(worldSize) * 2) - CGFloat(x + y))
				addChild(groundTile)
				var newStack = Stack<Item>()
				newStack.cartesianPoint = CGPoint(x: x, y: y)
				itemStacks.append(newStack)
			}
		}
		generateItems()
		generatePeople()
	}
	func generateMap (biome:String) {
		removeAllChildren()
		map.removeAll(keepCapacity: false)
		
		tileType = biome
		for var x = 0; x < worldSize; x++ {
			for var y = 0; y < worldSize; y++ {
				let groundTile = Tile(atPoint: CGPoint(x: x, y: y), spriteName: tileType)
				map.append(groundTile)
				groundTile.zPosition = CGFloat((CGFloat(worldSize) * 2) - CGFloat(x + y))
				addChild(groundTile)
			}
		}
		generateItems()
		generatePeople()
	}
	
	func resetWorld () {
		for stack in itemStacks {
			for item in stack.items {
				item.removeFromParent()
			}
		}
		itemStacks.removeAll(keepCapacity: false)
		for human in population {
			human.removeFromParent()
		}
		population.removeAll(keepCapacity: false)
		world.generateMap()
	}
	
	//----------------------------------------------------------------
	
	func generatePeople () {
		var generatedPeople = 0
		while generatedPeople != 8 {
			let tile = tileAtCartesian(CGPoint(x: randomInt(worldSize), y: randomInt(worldSize)))
			if !tile.occupied {//Double check tile isnt occupied to guarantee 8 spawns
				placePersonAtTile(tile)
				generatedPeople++
			}
		}
	}
	
	func placePersonAtTile (tile:Tile) {
		if !tile.occupied {
			tile.occupied = true
			let speciesArray:Array<String> = biomeData [tileType]! ["Species"]!
			let speciesName = speciesArray [randomInt(speciesArray.count)]
			let person = Person(atPoint: tile.cartesianPoint, species: speciesName)
			population.append(person)
			addChild(person)
		}
	}
	
	func generateItems () {
		for tile in world.map {
			if !tile.occupied && randomInt(5) == 0{
				placeItemOnTile(tile)
			}
		}
	}
	
	func placeItemOnTile(tile: Tile) {
		if !tile.occupied {
			for (index, var stack) in enumerate(itemStacks) {
				if stack.cartesianPoint == tile.cartesianPoint {
					if (stack.topItem?.isStackable ?? true) == true {
						let itemArray:Array<String> = biomeData [tileType]! ["Items"]!
						let itemName = itemArray [randomInt(itemArray.count)]
				
						let generatedItem = Item(itemID: itemName, atPoint: tile.cartesianPoint)
						generatedItem.position.y += CGFloat(stack.items.endIndex * 48)
						generatedItem.zPosition += CGFloat(stack.items.endIndex)
						stack.push(generatedItem)
						addChild(generatedItem)
						itemStacks[index] = stack
						tile.occupied = true
					}
					break
				}
			}
		}
	}
	func placeItemOnTile(item: Item, tile: Tile) {
		if !tile.occupied {
			for (index, var stack) in enumerate(itemStacks) {
				if stack.cartesianPoint == tile.cartesianPoint {
					if (stack.topItem?.isStackable ?? true) == true {
						item.position.y += CGFloat(stack.items.endIndex * 48)
						item.zPosition += CGFloat(stack.items.endIndex)
						stack.push(item)
						addChild(item)
						itemStacks[index] = stack
						tile.occupied = true
					}
					break
				}
			}
		}
	}
	
	func removeAtTile (tile:Tile) {
		if tile.occupied {
			var objectRemoved = false;
			for var i = 0; i < population.count; i++ {
				if population [i].cartesianPoint == tile.cartesianPoint && population [i].immediateDestination == tile.cartesianPoint {
					population[i].removeFromParent()
					tile.occupied = false
					population.removeAtIndex(i)
					objectRemoved = true
					break
				}
			}
			if !objectRemoved {
				for (index, var stack) in enumerate(itemStacks) {
					if stack.cartesianPoint == tile.cartesianPoint {
						if !stack.items.isEmpty { stack.pop().removeFromParent() }
						if stack.items.isEmpty { tile.occupied = false }
						itemStacks[index] = stack
						break
					}
				}
			}
		}
	}
}
