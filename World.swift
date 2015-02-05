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
	
	var population = Array<Person> ()
	var items = Array<Item> ()
	
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
		
		let tileTypes = ["Grass", "Sand", "Magma", "Ice", "Jungle"]
		tileType = tileTypes [randomInt(tileTypes.count)]
		for var x = 0; x < 12; x++ {
			for var y = 0; y < 12; y++ {
				let groundTile = Tile(atPoint: CGPoint(x: x, y: y), spriteName: tileType)
				map.append(groundTile)
				groundTile.zPosition = CGFloat(24 - CGFloat(x + y))
				addChild(groundTile)
			}
		}
		generateItems()
		generatePeople()
	}
	func generateMap (biome:String) {
		removeAllChildren()
		map.removeAll(keepCapacity: false)
		
		tileType = biome
		for var x = 0; x < 12; x++ {
			for var y = 0; y < 12; y++ {
				let groundTile = Tile(atPoint: CGPoint(x: x, y: y), spriteName: tileType)
				map.append(groundTile)
				groundTile.zPosition = CGFloat(24 - CGFloat(x + y))
				addChild(groundTile)
			}
		}
	}
	
	func resetWorld () {
		for item in items {
			item.removeFromParent()
		}
		items.removeAll(keepCapacity: false)
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
			let tile = tileAtCartesian(CGPoint(x: randomInt(12), y: randomInt(12)))
			if !tile.occupied && randomInt(10) == 0{
				tile.occupied = true
				
				let path = NSBundle.mainBundle().pathForResource("Biomes", ofType: "plist")
				let availableSpecies = NSDictionary(contentsOfFile: path!) as Dictionary<String, Dictionary<String, Array<String>>>
				let speciesArray:Array<String> = availableSpecies [tileType]! ["Species"]!
				let speciesName = speciesArray [randomInt(speciesArray.count)]
				
				let person = Person(atPoint: tile.cartesianPoint, species: speciesName, genderName: (randomInt(2) == 0) ? "Male" : "Female")
				population.append(person)
				addChild(person)
				generatedPeople++
			}
		}
	}
	
	func placePeople () {
		for tile in world.map {
			if tile.highlighted {
				tile.highlight()
				if !tile.occupied {
					tile.occupied = true
					let bias = (world.tileType == "Grass") ? "human" : (world.tileType == "Jungle") ? "argonian" : "none"
					let human = Person.randomPersonAtPoint(tile.cartesianPoint, world:world, speciesBias: bias)
					population.append(human)
					addChild(human)
				}
			}
		}
	}
	
	func generateItems () {
		for tile in world.map {
			if !tile.occupied && randomInt(10) == 0{
				tile.occupied = true
				
				let path = NSBundle.mainBundle().pathForResource("Biomes", ofType: "plist")
				let availableItems = NSDictionary(contentsOfFile: path!) as Dictionary<String, Dictionary<String, Array<String>>>
				let itemArray:Array<String> = availableItems [tileType]! ["Items"]!
				let itemName = itemArray [randomInt(itemArray.count)]
				
				let item = Item(itemID: itemName, atPoint: tile.cartesianPoint)
				items.append(item)
				addChild(item)
			}
		}
	}
	
	func placeItems () {
		for tile in world.map {
			if tile.highlighted {
				tile.highlight()
				if !tile.occupied {
					tile.occupied = true
					
					let path = NSBundle.mainBundle().pathForResource("Biomes", ofType: "plist")
					let availableItems = NSDictionary(contentsOfFile: path!) as Dictionary<String, Dictionary<String, Array<String>>>
					let itemArray:Array<String> = availableItems [tileType]! ["Items"]!
					let itemName = itemArray [randomInt(itemArray.count)]
					
					let item = Item(itemID: itemName, atPoint: tile.cartesianPoint)
					items.append(item)
					addChild(item)
				}
			}
		}
	}
	
	func removeThings () {
		for var i=0; i < items.count; i++ {
			if world.tileAtCartesian(items[i].cartesianPoint).highlighted {
				items[i].removeFromParent()
				world.tileAtCartesian(items[i].cartesianPoint).occupied = false
				items.removeAtIndex(i)
				i--
			}
		}
		for var i=0; i < population.count; i++ {
			if world.tileAtCartesian(population[i].cartesianPoint).highlighted {
				population[i].removeFromParent()
				world.tileAtCartesian(population[i].immediateDestination).occupied = false
				population.removeAtIndex(i)
				i--
			}
		}
	}
}
