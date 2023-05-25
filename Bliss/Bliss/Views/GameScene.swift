//
//  GameScene.swift
//  Bliss
//
//  Created by Angela Christabel on 18/05/23.
//

import SpriteKit
import GameplayKit
import Foundation

class GameScene: SKScene {
    let editGridMaxX: CGFloat = 293.0
    let editGridMinX: CGFloat = -293.0
    let editGridMaxY: CGFloat = -215.0
    let editGridMinY: CGFloat = 13.0
    
    var isEditing = false
    var isHoldingFurniture = false
    
    var tileManager = TileManager()
    var inventoryManager = InventoryManager()
    
    var currentFurniture: SKNode?
    var lastActiveTile: SKNode?
    var inventoryMenuIndex: Int = 0
    var inventoryIndex: Int?
    
    var backgroundNode: SKNode!
    var editBtnNode: SKSpriteNode!
    var inventoryMenuNode: SKSpriteNode!
    var storeBtnNode: SKSpriteNode!
    var characterNode: SKSpriteNode!
    
//    var shopBtnNode: SKNode!
    
    var previousCameraScale = CGFloat()
    var previousCameraPoint = CGPoint.zero
    var cameraNode: SKCameraNode!
    
    override func didMove(to view: SKView) {
        // init attributes
        backgroundNode = self.childNode(withName: "Background")
        editBtnNode = SKSpriteNode(texture: SKTexture(imageNamed: "Edit Button"))
        
        // edit position
        editBtnNode.position.x = self.frame.maxX - 75
        editBtnNode.position.y = self.frame.maxY - 50
        editBtnNode.size = CGSize(width: 50.0, height: 50.0)
        editBtnNode.zPosition = 500
        
        // generate furniture
        inventoryManager.generateInventory()
        for f in inventoryManager.inventory {
            if f.isPlaced {
                self.addChild(f)
            }
        }
        
        // generate tiles
        tileManager.generateTileGuide()
        for t in tileManager.tileNodes {
            let allNodes = self.nodes(at: t.position)
            for node in allNodes {
                if node.name?.contains("inventory") == true {
                    t.blockTile()
                }
            }
            
            self.addChild(t)
        }
        
        // Add character
        addCharacter()
        
        // add camera
        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint.zero
            
        self.addChild(cameraNode)
        self.camera = cameraNode
        
        // Create the gesture recognizer for panning
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanFrom))
        // Add the gesture recognizer to the scene's view
        self.view!.addGestureRecognizer(panGestureRecognizer)
        
        // add pinned objects
        self.camera?.addChild(editBtnNode)
        
        // gesture recognizer for zooming
        let pinchGesture = UIPinchGestureRecognizer()
        pinchGesture.addTarget(self, action: #selector(pinchGestureAction(_:)))
        self.view!.addGestureRecognizer(pinchGesture)
    }
    
    func addCharacter() {
        let spriteSize = CGSize(width: 80, height: 80)
        let spriteNode = SKSpriteNode(imageNamed: "Bleu-0")
        
        spriteNode.size = spriteSize
        spriteNode.position = CGPoint(x: -5.0, y: -118)
        spriteNode.zPosition = 102
        self.addChild(spriteNode)
        
        let textureNames = ["Bleu-1", "Bleu-2", "Bleu-3", "Bleu-4", "Bleu-5", "Bleu-6", "Bleu-7", "Bleu-8", "Bleu-9", "Bleu-10", "Bleu-11", "Bleu-12", "Bleu-13", "Bleu-14", "Bleu-15", "Bleu-16", "Bleu-17", "Bleu-18", "Bleu-19", "Bleu-20", "Bleu-21", "Bleu-22", "Bleu-23", "Bleu-24", "Bleu-25", "Bleu-26"]

        let textures = textureNames.map { SKTexture(imageNamed: $0) }
        let animationAction = SKAction.animate(with: textures, timePerFrame: 0.07)
        let repeatAction = SKAction.repeatForever(animationAction)
        spriteNode.run(repeatAction)
        
        characterNode = spriteNode
    }
    
    func activateTileAtLocation(_ location: CGPoint) {
        let nodes = self.nodes(at: location)
        
        tileManager.deactivateTiles()
        
        for n in nodes {
            if n.name == "tile" {
                let tile = n as? TileNode
                tile!.highlight()
                lastActiveTile = tile
                break
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNodes = nodes(at: location)
        
            for node in touchedNodes {
                if node == editBtnNode {
                    handleEditBtn()
                }
                
                // user is holding a inventory item
                if isEditing && node.name?.contains("inventory") == true  {
                    let inventory = node as? InventoryNode
                    if let inventory = inventory {
                        if inventory.isPlaced {
                            activateTileAtLocation(location)
                            
                            isHoldingFurniture = true
                            currentFurniture = inventory
                            inventoryIndex = inventory.id
                            
                            generateRestoreBtn(node: inventory)
                        }
                    }
                }
                
                // if user is holding an inventory card from the inventory menu
                if isEditing && node.name?.contains("card") == true {
                    // extract inventory ID
                    let split = node.name?.split(separator: "_").map{ String($0) }[1]
                    // try to extract index
                    guard let invIdx = Int(split!) else {
                        print("Failed to extract inventory index")
                        break
                    }

                    let selectedInv = inventoryManager.inventory[invIdx]
                    if !selectedInv.isPlaced {
                        print("clicked card")
                        selectedInv.position = location
                        currentFurniture = selectedInv
                        isHoldingFurniture = true
                        inventoryIndex = invIdx

//                        self.addChild(selectedInv)

                        // TODO: handle when user click card but didn't drag it
                    }
                }
                
                if isEditing && node == storeBtnNode {
                    handleStoreBtn()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func removeRestoreBtn() {
        if let btn = self.childNode(withName: "storeBtn") {
            self.removeChildren(in: [btn])
        }
    }
    
    func generateRestoreBtn(node: SKNode) {
        removeRestoreBtn()
        
        storeBtnNode = SKSpriteNode(texture: SKTexture(imageNamed: "Store icon"))
        storeBtnNode.name = "storeBtn"
        storeBtnNode.position.x = node.position.x
        storeBtnNode.position.y = node.position.y + node.frame.height/2 + 20
        storeBtnNode.zPosition = 200
        self.addChild(storeBtnNode)
    }
    
    func handleStoreBtn() {
        guard let furn = self.currentFurniture as? InventoryNode else {
            print("Failed to convert to InventoryNode during store button")
            return
        }
        
        removeRestoreBtn()
        
        if let idx = inventoryIndex {
            let card = inventoryManager.inventoryCards[idx]
            
            furn.isPlaced = false
            inventoryManager.enableInventoryCard(card: card, inventory: furn)
            
            tileManager.deactivateTiles()
            self.removeChildren(in: [furn])
            currentFurniture = nil
            isHoldingFurniture = false
            inventoryIndex = nil
            
            let storeSound = SKAction.playSoundFileNamed("StoreButtonSound.mp3", waitForCompletion: false)
            self.run(storeSound)
        }
    }
    
    func handleEditBtn() {
        isEditing.toggle()

        let editSound = SKAction.playSoundFileNamed("EditButtonSound.mp3", waitForCompletion: false)
        self.run(editSound)
        
        if isEditing == false {
            editBtnNode.texture = SKTexture(imageNamed: "Edit Button")
            tileManager.deactivateTiles()
            removeRestoreBtn()
            self.camera?.removeChildren(in: [inventoryMenuNode])
            self.camera?.removeChildren(in: inventoryManager.inventoryCards)
        } else {
            // if we are editing
            // TODO: tambahain transition pake SKAction or something

            editBtnNode.texture = SKTexture(imageNamed: "Stop Editing Button")
            
            let inventoryTexture = SKTexture(imageNamed: "Inventory Menu")
            inventoryMenuNode = SKSpriteNode(texture: inventoryTexture, size: inventoryTexture.size())
            inventoryMenuNode.position.x = self.frame.midX / 2 - inventoryMenuNode.size.width * 1.15
            inventoryMenuNode.position.y = self.frame.midY
            inventoryMenuNode.zPosition = 150
            
            self.camera?.addChild(inventoryMenuNode)
            
            for card in inventoryManager.generateInventoryCards(menu: inventoryMenuNode, index: inventoryMenuIndex) {
                self.camera?.addChild(card)
            }
        }
    }
    
    @objc func handlePanFrom(_ sender: UIPanGestureRecognizer) {
        // This function is called when a pan gesture is recognized. Respond with code here.
        if !isHoldingFurniture {
            // The camera has a weak reference, so test it
            guard let camera = self.camera else {
                print("no camera")
                return
            }
            
            // If the movement just began, save the first camera position
            if sender.state == .began {
              previousCameraPoint = camera.position
            }
            // Perform the translation
            let translation = sender.translation(in: self.view)
            
            var newX = previousCameraPoint.x + translation.x * -1
            var newY = previousCameraPoint.y + translation.y
            
            newX = max(-backgroundNode.frame.width/2 + self.frame.width/2, newX)
            newX = min(newX, backgroundNode.frame.width/2 - self.frame.width/2)

            newY = max(-backgroundNode.frame.height/2 + self.frame.height/2, newY)
            newY = min(newY, backgroundNode.frame.height/2 - self.frame.height/2)
            
            let newPosition = CGPoint(x: newX, y: newY)
            camera.position = newPosition
        } else {
            guard let furn = self.currentFurniture as? InventoryNode else {return}
            
            // check if furniture is already on screen
            var childExists = false
            for child in self.children {
                if furn == child {
                    childExists = true
                    break
                }
            }
            
            if !childExists {
                self.addChild(furn)
            }
            
            let translation = sender.translation(in: self.view)
            var newX = translation.x
            var newY = translation.y * -1
            var newPosition = CGPoint(x: newX, y: newY)
            
            // if scrolling has ended
            if sender.state == .ended {
                if newX < editGridMinX || newX > editGridMaxX || newY < editGridMinY || newY > editGridMaxY {
                    newX = lastActiveTile!.position.x
                    newY = lastActiveTile!.position.y + furn.furniture.offsetY
                    
                    newPosition = CGPoint(x: newX, y: newY)
                }
                
                if let idx = inventoryIndex {
                    furn.isPlaced = true
                    let card = inventoryManager.inventoryCards[idx]
                    inventoryManager.disableInventoryCard(card: card, name: furn.furniture.inventoryImage)
                }
                
                furn.position = newPosition
                generateRestoreBtn(node: furn)
                
                print("ended holding furniture")
                
                isHoldingFurniture = false
                let moveSound = SKAction.playSoundFileNamed("MoveInventorySound.mp3", waitForCompletion: false)
                self.run(moveSound)
            }
            
            if sender.state == .began {
                removeRestoreBtn()
            }
            
            furn.position = newPosition
            
            let nodes = self.nodes(at: newPosition)
            for n in nodes {
                if n.name == "tile" {
                    let tile = n as? TileNode
                    
                    newX = tile!.position.x
                    newY = tile!.position.y + furn.furniture.offsetY
                    
                    newPosition = CGPoint(x: newX, y: newY)
                    furn.position = newPosition
                    
                    activateTileAtLocation(newPosition)

                    break
                }
            }
        }
    }
    
    @objc func pinchGestureAction(_ sender: UIPinchGestureRecognizer) {
        guard let camera = self.camera else {return}
        
        if sender.state == .began {
            previousCameraScale = camera.xScale
        }
        
        var newScale = previousCameraScale * 1 / sender.scale
        newScale = min(1, newScale)
        newScale = max(0.5, newScale)
        print(newScale)
        
        camera.setScale(newScale)
    }
}
