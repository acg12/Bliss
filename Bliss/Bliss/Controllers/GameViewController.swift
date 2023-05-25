//
//  GameViewController.swift
//  Bliss
//
//  Created by Angela Christabel on 18/05/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var scene: SKScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let sc = SKScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                sc.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(sc)
                
                self.scene = sc
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
