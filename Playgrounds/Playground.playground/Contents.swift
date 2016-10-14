//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
import Anymotion

/*
 # Group
 */

let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
view.backgroundColor = UIColor(colorLiteralRed: 254/255, green: 210/255, blue: 0, alpha: 1)

let goLeft = ANYUIView.animation(duration: 2.5, delay: 0.0, options: .allowUserInteraction, block: {
    view.center.x = 25
})
let goRight = ANYUIView.animation(duration: 2.5, delay: 0.0, options: .allowUserInteraction, block: {
    view.center.x = 765-25
})

goRight.then(goLeft).repeat().start()

let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 765, height: 50))
containerView.backgroundColor = .white
containerView.clipsToBounds = false
containerView.addSubview(view)

PlaygroundPage.current.liveView = containerView



/*
 # Group
 */
