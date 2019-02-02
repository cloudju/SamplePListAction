//
//  PListAction.swift
//  SamplePListAction
//
//  Created by 居朝強 on 2019/01/28.
//  Copyright © 2019 居朝強. All rights reserved.
//


import SpriteKit
import Foundation

class PListAnimation{
    let plist : PList
    let originTexture : SKTexture
    
    var textures : [SKTexture]?  = nil
    var sprit : SKSpriteNode? = nil
    var action : SKAction? = nil
    
    var timePerFrame : TimeInterval = 0.05
    
    init(plist:String, image:String) {
        self.plist = PList(plist)
        self.originTexture = SKTexture(imageNamed: image)
    }
    
    func getSprit()->SKSpriteNode{
        if sprit == nil {
            sprit = SKSpriteNode(texture: getTextures()[0])
        }
        return sprit!
    }
    
    func getAction()->SKAction{
        if action == nil{
            if textures == nil{
                textures = getTextures()
            }
            action = SKAction.animate(with: textures!, timePerFrame: self.timePerFrame)
        }
        return action!
    }
    
    private func getTextures()->[SKTexture]{
        var textures:[SKTexture] = []
        for frame in self.plist.getFrames()!{
            let rect = frame.getRect()
            let croppedTexture = SKTexture(rect: rect,in: self.originTexture)
            textures.append(croppedTexture)
        }
        return textures
    }
}

class PList {
    var meta:PListMeta? = nil
    var frames : [Frame] = []
    
    let data : NSDictionary;
    
    init(_ plist:String){
        let url = URL(fileReferenceLiteralResourceName: plist)
        data = NSDictionary(contentsOf: url)!
    }
    
    func getFrames()->[Frame]?{
        if  frames.count == 0{
            let fs = data.object(forKey: "frames") as! NSDictionary
            var keys = fs.allKeys as! [String]
            keys.sort(by: {$0.localizedStandardCompare($1)==ComparisonResult.orderedAscending})
            
            for key in keys{
                let frameDic = fs.object(forKey: key) as! NSDictionary
                let frame = Frame(frameDic,meta: getMeta())
                self.frames.append(frame)
            }
        }
        return frames
        
    }
    
    func getMeta()->PListMeta
    {
        if(meta == nil){
            let m = data.object(forKey: "metadata") as! NSDictionary
            meta = PListMeta(m)
        }
        return meta!
    }
}

class PListMeta{
    let size : CGSize
    init(_ m:NSDictionary){
        var sizeStr = m.object(forKey:"size") as! String
        sizeStr = sizeStr.replacingOccurrences(of: "{", with: "")
        sizeStr = sizeStr.replacingOccurrences(of: "}", with: "")
        let v = sizeStr.split(separator: ",")
        size = CGSize(width: Int(v[0])!, height: Int(v[1])!)
    }
}

class Frame {
    private var rect : CGRect? = nil
    private let data : NSDictionary
    private let meta :PListMeta
    init(_ f:NSDictionary,meta:PListMeta) {
        self.meta = meta
        data = f
    }
    
    func getRect()->CGRect{
        if(rect == nil){
            let frameStr = data.object(forKey: "frame") as! String
            rect = str2rec(frameStr)
            rect = fixRect(rect!,by:meta.size)
        }
        
        return rect!
    }
    
    private func fixRect(_ intRect:CGRect, by metaSize: CGSize)->CGRect{
        let xRate = 1.0 / metaSize.width as CGFloat
        let yRate = 1.0 / metaSize.height as CGFloat
        
        let x = xRate * intRect.minX
        let w = xRate * intRect.width
        let h = yRate * intRect.height
        let y = 1.0 - yRate * intRect.minY - h
        
        return CGRect(x: x, y: y, width: w, height: h)
    }
    
    private func str2rec(_ x:String)->CGRect{
        var str = x.replacingOccurrences(of: "{", with: "")
        str = str.replacingOccurrences(of: "}", with: "")
        
        let v = str.split(separator: ",")
        
        return CGRect(x: Int(v[0])!, y: Int(v[1])!, width: Int(v[2])!, height: Int(v[3])!)
    }
    
    
}
