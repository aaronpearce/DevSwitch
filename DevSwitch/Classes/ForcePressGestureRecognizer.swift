//
//  ForcePressGestureRecognizer.swift
//  DevSwitch
//
//  Created by Aaron Pearce on 1/03/19.
//  Copyright © 2019 Aaron Pearce. All rights reserved.
//

import UIKit.UIGestureRecognizerSubclass

@available(iOS 9.0, *)
final class ForceTouchGestureRecognizer: UIGestureRecognizer {
    
    private let threshold: CGFloat = 0.75
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            handleTouch(touch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            handleTouch(touch)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        state = UIGestureRecognizer.State.failed
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesCancelled(touches, with: event)
        state = UIGestureRecognizer.State.failed
    }
    
    private func handleTouch(_ touch: UITouch) {
        guard touch.force != 0 && touch.maximumPossibleForce != 0 else { return }
        
        if touch.force / touch.maximumPossibleForce >= threshold {
            state = UIGestureRecognizer.State.recognized
        }
    }
    
}
