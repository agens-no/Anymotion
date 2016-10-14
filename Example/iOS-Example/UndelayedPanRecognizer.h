//
//  UndelayedPanRecognizer.h
//  iOS-Example
//
//  Created by Håvard Fossli on 14.10.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UndelayedPanRecognizer : UIGestureRecognizer

- (CGPoint)translationInView:(UIView *)view;
- (CGPoint)velocityInView:(UIView *)view;

@end
