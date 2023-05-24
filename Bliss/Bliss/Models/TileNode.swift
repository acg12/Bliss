//
//  TileNode.swift
//  Bliss
//
//  Created by Angela Christabel on 21/05/23.
//

import Foundation
import SpriteKit

class TileNode: SKSpriteNode {
    let id = UUID()
    var isOccupied = false
    
    func highlight() {
        // Apply the desired visual effect to indicate the square is a valid drop area
        // For example, you can change the square's color or add a glow effect
//        if isOccupied {
//            self.alpha = 1.0
//        } else {
//            self.alpha = 0.5
//        }
        
        self.alpha = 1.0
    }
    
    func reset() {
        // Reset the square's appearance to its original state
//        self.color = .white
        self.alpha = 0.0001
    }
    
    func blockTile() {
        self.isOccupied = true
    }
}
