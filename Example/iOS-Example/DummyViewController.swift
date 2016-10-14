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
        
        
    }
    
}
