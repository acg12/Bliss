//
//  FurnitureManager.swift
//  Bliss
//
//  Created by Angela Christabel on 22/05/23.
//

import Foundation
import SpriteKit

class InventoryManager {
    var inventory: [InventoryNode] = []
    var inventoryCards: [SKSpriteNode] = []
    
    func generateInventory() {
        let inventoryInfo = Bundle.main.decode([Inventory].self, from: "inventory.json")
        
        for i in 0..<inventoryInfo.count {
            let f = inventoryInfo[i]
            let node = InventoryNode(id: i, furniture: f.furniture, isPlaced: f.isPlaced)
            node.zPosition = 100
            node.position = CGPoint(x: f.x, y: (f.y + f.furniture.offsetY))
            node.size.width = f.furniture.width
            node.size.height = f.furniture.height
            node.name = "inventory_\(f.furniture.name)"
            
            inventory.append(node)
        }
    }
    
    func generateInventoryCards(menu: SKSpriteNode, index pageIndex: Int) -> [SKSpriteNode] {
        self.inventoryCards.removeAll()
        
        var generatedCards: [SKSpriteNode] = []
        let rowGutter: CGFloat = 7
        let colGutter: CGFloat = 19
        
        for row in 0..<3 {
            for col in 0..<3 {
                let finalIdx = (row * 3 + col) + (pageIndex * 9)
                if finalIdx < inventory.count {
                    let inv = inventory[finalIdx]
                    var imageName = inv.furniture.inventoryImage
                    
                    if inv.isPlaced {
                        imageName += "_disabled"
                    }
                    
                    let texture = SKTexture(imageNamed: imageName)
                    let node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
                    node.name = "card_\(finalIdx)_\(inv.furniture.name)"
                    
                    let offsetX: CGFloat = (node.size.width + colGutter) * CGFloat(col)
                    let offsetY: CGFloat = (node.size.height + rowGutter) * CGFloat(row)
                    
                    let posX: CGFloat = menu.position.x + 19 + offsetX - menu.size.width/2 + node.size.width/2
                    let posY: CGFloat = menu.position.y - 51 - offsetY + menu.size.height/2 - node.size.height/2
                    
                    node.position.x = posX
                    node.position.y = posY
                    node.zPosition = 151
                    generatedCards.append(node)
                    self.inventoryCards.append(node)
                } else {
                    break
                }
            }
        }
        return generatedCards
    }
    
    func disableInventoryCard(card: SKSpriteNode, name: String) {
        let imageName = "\(name)_disabled"
        card.texture = SKTexture(imageNamed: imageName)
    }
    
    func enableInventoryCard(card: SKSpriteNode, inventory: InventoryNode) {
        card.texture = SKTexture(imageNamed: inventory.furniture.inventoryImage)
    }
}
