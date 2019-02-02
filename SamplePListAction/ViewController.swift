//
//  ViewController.swift
//  SamplePListAction
//
//  Created by 居朝強 on 2019/01/28.
//  Copyright © 2019 居朝強. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController {

    //    @IBOutlet var skView: SKView!
    override func loadView() {
        // viewをSKViewに設定
        let skView = SKView(frame: (NSScreen.main?.frame)!)
        self.view = skView
        
    }
    override func viewDidLoad() {
        let scene = GameScene(size:(NSScreen.main?.frame.size)!)
        scene.scaleMode = .aspectFit
        let skView = self.view as! SKView
        skView.presentScene(scene)
    }
}

