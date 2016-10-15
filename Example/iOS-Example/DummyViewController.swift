//
//  Dummy.swift
//  iOS-Example
//
//  Created by Håvard Fossli on 14.10.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

import Foundation
import UIKit
import Anymotion

class DummyViewController : UIViewController {
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
        title = "Dummy"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let foo = UIView()
        foo.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        foo.backgroundColor = .blue
        view.addSubview(foo)
        
        let spring = ANYPOPSpring(kPOPLayerPositionX).fromValue(0).toValue(100).springSpeed(5).animation(for: view)
        let basic = ANYPOPBasic(kPOPLayerPositionX).fromValue(0).toValue(100).duration(2).animation(for: view)
        let decay = ANYPOPDecay(kPOPLayerPositionX).fromValue(0).velocity(10).animation(for: view)
        
        let caBasic = ANYCABasic(#keyPath(CALayer.position)).duration(2).fromValue(CGPoint.zero).toValue(CGPoint(x: 100, y: 0)).animation(for: view.layer)
        let caKeyframe = ANYCAKeyframe(#keyPath(CALayer.opacity)).values([0, 0.5, 1]).animation(for: view.layer)
        
        let uikit = ANYUIView.animation(duration: 2) { 
            foo.center.x = 100
        }
        
        ANYAnimation.group([spring, basic, decay, caBasic, caKeyframe, uikit]).start()
        
        
    }
    
}
