//
//  MenuScene.swift
//  Bliss
//
//  Created by Angela Christabel on 24/05/23.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    var title: SKLabelNode!
    var caption: SKLabelNode!
    var start: SKLabelNode!
    var startBtn: SKShapeNode!
    
    override func didMove(to view: SKView) {
        // set text to brown
        title = self.childNode(withName: "Title") as? SKLabelNode
        title.fontColor = UIColor(named: "Liver Brown")
        title.zPosition = 1
        
        caption = self.childNode(withName: "Caption") as? SKLabelNode
        caption.fontColor = UIColor(named: "Liver Brown")
        caption.zPosition = 1
        
        start = self.childNode(withName: "StartText") as? SKLabelNode
        start.fontColor = UIColor(named: "Liver Brown")
        start.zPosition = 2
        
        // Make the button
        let size = CGSize(width: 152, height: 43)
        let cornerRadius: CGFloat = 100
        let roundedRect = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
        startBtn = SKShapeNode(path: roundedRect.cgPath)

        // Set the appearance of the shape
        startBtn.fillColor = UIColor(named: "Gray White") ?? .white
        startBtn.strokeColor = UIColor(named: "Liver Brown") ?? .black
        startBtn.lineWidth = 3
        startBtn.position.x = start.position.x - startBtn.frame.width/2
        startBtn.position.y = start.position.y - startBtn.frame.height/2 + start.frame.height/2
        startBtn.zPosition = 1
        
        self.addChild(startBtn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
            
            for node in nodes {
                if node == startBtn {
                    if let scene = SKScene(fileNamed: "GameScene") {
                        // Set the scale mode to scale to fit the window
                        scene.scaleMode = .aspectFill
                        
                        // Present the scene
                        let transition = SKTransition.fade(withDuration: 2)
                        self.view?.presentScene(scene, transition: transition)
                    }
                }
            }
        }
    }
}
