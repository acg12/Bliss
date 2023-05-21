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
    var backgroundNode: SKNode!
    var editBtnNode: SKSpriteNode!
//    var userNode: SKNode!
//    var shopBtnNode: SKNode!
//    var furnitureNodes: [SKNode] = []
    
    var previousCameraPoint = CGPoint.zero
    var cameraNode: SKCameraNode!
    
    var tilesArray: [SKShapeNode] = []
    
    override func didMove(to view: SKView) {
        // init attributes
        backgroundNode = self.childNode(withName: "Background")
        editBtnNode = SKSpriteNode(color: .blue, size: .init(width: 50, height: 50))
        
        // edit position
        editBtnNode.position.x = self.frame.maxX - 75
        editBtnNode.position.y = self.frame.maxY - 75
        editBtnNode.zPosition = 100
        
        
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
    
    
    @objc func handlePanFrom(_ sender: UIPanGestureRecognizer) {
        // This function is called when a pan gesture is recognized. Respond with code here.
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
        
        // Reset the position of the editBtnNode
        editBtnNode.position = CGPoint(x: self.frame.maxX - 75, y: self.frame.maxY - 75)
    }
}
