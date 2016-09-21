//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

/*
# Group
 */

let view = UIView.init(frame: CGRect.init(x: 200, y: 200, width: 200, height: 200))
view.backgroundColor = .green


let containerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 375.0, height: 667.0))
containerView.backgroundColor = .blue
PlaygroundPage.current.liveView = containerView

