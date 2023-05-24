//
//  TileManager.swift
//  Bliss
//
//  Created by Angela Christabel on 22/05/23.
//

import Foundation
import SpriteKit

class TileManager {
    var tileNodes: [TileNode] = []
    
    func generateTileGuide() {
        let width: CGFloat = 65.0
        let height: CGFloat = 26.0
        let startX = -293.0
        let startY = 13.0
        
        let n = 10
        var space = n - 1
        var x = startX
        var y = startY
            
        // Run loop (parent loop) till number of rows
        for i in 0..<n-1 {
            // Loop for initially space, before star printing
            x = startX
            for _ in 0..<space {
                x += width/2
            }
            
            // Print i+1 stars
            for _ in 0...i {
                let square = drawTileGuide(width: width, height: height, x: x, y: y)
                tileNodes.append(square)
                x += width
            }
            y -= height/2
            space -= 1
        }
        
        // Print middle row
        x = startX
        for _ in 0..<n {
            let square = drawTileGuide(width: width, height: height, x: x, y: y)
            tileNodes.append(square)
            x += width
        }
        
        // Repeat again in reverse order
        y -= height/2
        space = 1
        
        // Run loop (parent loop) till number of rows
        for i in stride(from: n-2, to: -1, by: -1) {
            x = startX
            for _ in 0..<space {
                x += width/2
            }
            
            // Print i+1 stars
            for _ in 0...i {
                let square = drawTileGuide(width: width, height: height, x: x, y: y)
                tileNodes.append(square)
                x += width
            }
            y -= height/2
            space += 1
        }
    }
    
    func drawTileGuide(width: CGFloat, height: CGFloat, x: CGFloat, y: CGFloat) -> TileNode {
        let square = TileNode(texture: SKTexture(imageNamed: "TileGuide"), size: CGSize(width: width, height: height))
        square.position = CGPoint(x: x, y: y)
        square.zPosition = 2
        square.alpha = 0.0001
        square.name = "tile"
        
        square.physicsBody = SKPhysicsBody(texture: square.texture!, size: square.texture!.size())
        square.physicsBody?.mass = 0.0001
        square.physicsBody?.categoryBitMask = CollisionType.tile.rawValue
        square.physicsBody?.collisionBitMask = CollisionType.inventory.rawValue
        square.physicsBody?.contactTestBitMask = CollisionType.inventory.rawValue
        square.physicsBody?.isDynamic = false
        return square
    }
    
    func deactivateTiles() {
        for i in 0..<tileNodes.count {
            let tile = tileNodes[i]
            tile.reset()
        }
    }
    
    func activateTiles() {
        for i in 0..<tileNodes.count {
            let tile = tileNodes[i]
            tile.highlight()
        }
    }
}
