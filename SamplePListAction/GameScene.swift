//
//  GameScene.swift
//  SamplePListAction
//
//  Created by 居朝強 on 2019/01/28.
//  Copyright © 2019 居朝強. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let p = PListAnimation(plist:"boom.plist",image:"boom.png")
    
    override func didMove(to view: SKView) {
        
    }
    
    
    override func mouseDown(with event: NSEvent) {
        let sprite = p.getSprit()
        sprite.removeFromParent()
        sprite.position = event.location(in: self)
        self.addChild(sprite)
        p.timePerFrame = 0.1
        let action = p.getAction()
//        sprite.run(action, completion: {sprite.removeFromParent()})
        sprite.run(action)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
