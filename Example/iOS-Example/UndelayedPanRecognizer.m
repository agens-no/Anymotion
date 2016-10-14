//
//  UndelayedPanRecognizer.m
//  iOS-Example
//
//  Created by Håvard Fossli on 14.10.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "UndelayedPanRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface UndelayedPanRecognizer ()

@property (nonatomic, strong) UITouch *touch;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint prevPoint;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) NSTimeInterval prevTime;
@property (nonatomic, assign) NSTimeInterval currentTime;

@end

@implementation UndelayedPanRecognizer

- (void)reset
{
    self.touch = nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if(self.touch == nil)
    {
        self.touch = [touches anyObject];
        
        self.currentPoint = [self.touch locationInView:self.view];
        self.startPoint = self.currentPoint;
        self.prevPoint = self.currentPoint;
        
        self.currentTime = CFAbsoluteTimeGetCurrent();
        self.prevTime = self.currentTime;
        
        self.state = UIGestureRecognizerStateBegan;
    }
    
    for(UITouch *touch in touches)
    {
        if(touch != self.touch)
        {
            [self ignoreTouch:touch forEvent:event];
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([touches containsObject:self.touch])
    {
        self.prevPoint = self.currentPoint;
        self.currentPoint = [self.touch locationInView:self.view];
        
        self.prevTime = self.currentTime;
        self.currentTime = CFAbsoluteTimeGetCurrent();
        
        self.state = UIGestureRecognizerStateChanged;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([touches containsObject:self.touch])
    {
        self.state = UIGestureRecognizerStateCancelled;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if([touches containsObject:self.touch])
    {
        self.state = UIGestureRecognizerStateEnded;
    }
}

- (CGPoint)translationInView:(UIView *)view
{
    return [self translationInView:view start:self.startPoint end:self.currentPoint];
}

- (CGPoint)translationInView:(UIView *)view start:(CGPoint)start end:(CGPoint)end
{
    CGPoint startConverted = [self.view convertPoint:start toView:view];
    CGPoint endConverted = [self.view convertPoint:end toView:view];
    return CGPointMake(startConverted.x - endConverted.x, startConverted.y - endConverted.y);
}

- (CGPoint)velocityInView:(UIView *)view
{
    NSTimeInterval now = CFAbsoluteTimeGetCurrent();
    NSTimeInterval timeDiff = now - self.prevTime;
    CGPoint prevTranslation = [self translationInView:view start:self.prevPoint end:self.currentPoint];
    CGPoint velocity = CGPointMake(-prevTranslation.x / timeDiff,
                                   -prevTranslation.y / timeDiff);
    return velocity;
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"%@ {", [super description]];
    
    [description appendFormat:@"\n\ttouch: %@", _touch];
    [description appendFormat:@"\n\tstartPoint: %@", NSStringFromCGPoint(_startPoint)];
    [description appendFormat:@"\n\tprevPoint: %@", NSStringFromCGPoint(_prevPoint)];
    [description appendFormat:@"\n\tcurrentPoint: %@", NSStringFromCGPoint(_currentPoint)];
    [description appendFormat:@"\n\tprevTime: %f", _prevTime];
    
    [description appendString:@"\n}"];
    
    return description;
}

@end
