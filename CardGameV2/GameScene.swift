/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import SpriteKit

class GameScene: SKScene {
    
    enum CardLevel :CGFloat {
        case board = 10
        case moving = 100
        case enlarged = 200
    }

    override func didMoveToView(view: SKView) {

        let bg = SKSpriteNode(imageNamed: "bg_blank")
        bg.anchorPoint = CGPoint.zero
        bg.position = CGPoint.zero
        addChild(bg)
    
        let wolf = Card(cardType: .Wolf)
        wolf.position = CGPointMake(100,200)
        addChild(wolf)
    
        let bear = Card(cardType: .Bear)
        bear.position = CGPointMake(300, 200)
        addChild(bear)

    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)           // 1
            if let card = nodeAtPoint(location) as? Card {      // 2
                card.position = location
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if let card = nodeAtPoint(location) as? Card {
                //Wiggle
                let wiggleIn = SKAction.scaleXTo(1.0, duration: 0.2)
                let wiggleOut = SKAction.scaleXTo(1.2, duration: 0.2)
                let wiggle = SKAction.sequence([wiggleIn, wiggleOut])
                
                card.runAction(SKAction.repeatActionForever(wiggle), withKey: "wiggle")
                
                //Rotate
//                let rotR = SKAction.rotateByAngle(0.15, duration: 0.2)
//                let rotL = SKAction.rotateByAngle(-0.15, duration: 0.2)
//                let cycle = SKAction.sequence([rotR, rotL, rotL, rotR])
//                let wiggle = SKAction.repeatActionForever(cycle)
//                card.runAction(wiggle, withKey: "rotate") //Should be rotate instead "wiggle" like in tutorial link
                
                card.zPosition = CardLevel.moving.rawValue
                card.removeActionForKey("drop")
                card.runAction(SKAction.scaleTo(1.3, duration: 0.25), withKey: "pickup")

            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if let card = nodeAtPoint(location) as? Card {
                card.zPosition = CardLevel.board.rawValue
                card.removeFromParent()
                addChild(card)
                //Wiggle
                card.removeActionForKey("wiggle")
                
                //Rotate
//                card.runAction(SKAction.rotateToAngle(0, duration: 0.2), withKey:"rotate")

                card.removeActionForKey("pickup")
                card.runAction(SKAction.scaleTo(1.0, duration: 0.25), withKey: "drop")
            }
        }
    }

}












