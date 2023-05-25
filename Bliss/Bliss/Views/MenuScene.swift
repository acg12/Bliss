//
//  MenuScene.swift
//  Bliss
//
//  Created by Angela Christabel on 24/05/23.
//

import Foundation
import SpriteKit

class MenuScene: SKScene {
    var lblStart: SKLabelNode?
    var backgroundSound: SKAudioNode!
    
    override func didMove(to view: SKView) {
        lblStart = self.childNode(withName: "StartBtn") as? SKLabelNode
        
        // add audio
        if let musicURL = Bundle.main.url(forResource: "Bliss BGM", withExtension: "mp3") {
            backgroundSound = SKAudioNode(url: musicURL)
            self.addChild(backgroundSound)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let nodes = self.nodes(at: touch.location(in: self))
            
            for node in nodes {
                if node == lblStart {
                    print("pressed start")
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
