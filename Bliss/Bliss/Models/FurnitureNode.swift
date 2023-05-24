//
//  FurnitureNode.swift
//  Bliss
//
//  Created by Angela Christabel on 22/05/23.
//

import Foundation
import SpriteKit

class FurnitureNode: SKSpriteNode {
    var image: String
    var price: Int
    var offsetY: CGFloat
    var inventoryImage: String
    
    init(image: String, price: Int, offsetY: CGFloat, inventoryImage: String) {
        self.image = image
        self.price = price
        self.offsetY = offsetY
        self.inventoryImage = inventoryImage
        
        let texture = SKTexture(imageNamed: image)
        super.init(texture: texture, color: .white, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Furniture: Codable {
    var name: String
    var image: String
    var price: Int
    var offsetY: CGFloat
    var inventoryImage: String
}
