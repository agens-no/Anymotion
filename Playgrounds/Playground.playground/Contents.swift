//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import Anymotion

/*
 # Group
 */

let view = UIView.init(frame: CGRect.init(x: 200, y: 200, width: 200, height: 200))
view.backgroundColor = .green

let goLeft = ANYUIView.animation(withDuration: 0.5, delay: 0.0, options: .allowUserInteraction, block: {
    view.center.x = 0
})
let goRight = ANYUIView.animation(withDuration: 0.5, delay: 0.0, options: .allowUserInteraction, block: {
    view.center.x = 375
})

goLeft.then(goRight).repeat().start()

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0))
containerView.backgroundColor = .white
containerView.addSubview(view)

PlaygroundPage.current.liveView = containerView

/*
 # Group
 */
