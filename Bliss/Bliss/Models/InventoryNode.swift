//
//  InventoryNode.swift
//  Bliss
//
//  Created by Angela Christabel on 23/05/23.
//

import Foundation
import SpriteKit

class InventoryNode: SKSpriteNode {
    var id: Int
    var furniture: Furniture
    var isPlaced: Bool
    
    init(id: Int, furniture: Furniture, isPlaced: Bool) {
        self.id = id
        self.furniture = furniture
        self.isPlaced = isPlaced
        
        let texture = SKTexture(imageNamed: self.furniture.image)
        super.init(texture: texture, color: .white, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Inventory: Codable {
    var furniture: Furniture
    var x: CGFloat
    var y: CGFloat
    var isPlaced: Bool
}
