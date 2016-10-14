//
// Authors: Mats Hauge <mats@agens.no>
//          Håvard Fossli <hfossli@agens.no>
//
// Copyright (c) 2013 Agens AS (http://agens.no/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ANYUIView.h"
#import <UIKit/UIKit.h>
#import "ANYCoreAnimationObserver.h"
#import "ANYCALayerAnimationBlockDelegate.h"

@interface ANYUIView ()
@end

@implementation ANYUIView

+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration block:(void(^)(void))block
{
    return [self animationWithDuration:duration delay:0 options:0 block:block];
}

+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options block:(void(^)(void))block
{
    return [self animationWithDuration:duration delay:0 options:options block:block];
}

+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay block:(void(^)(void))block
{
    return [self animationWithDuration:duration delay:delay options:0 block:block];
}

+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options block:(void(^)(void))block
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        
        NSMutableArray <CAAnimation *> *completed = [NSMutableArray new];
        NSMutableArray <CAAnimation *> *failed = [NSMutableArray new];
        NSArray <ANYCoreAnimationChange *> *added = [[ANYCoreAnimationObserver shared] addedAnimations:^{
            [UIView animateWithDuration:duration delay:delay options:options animations:^{
                block();
            } completion:^(BOOL finished) {
                [subscriber completed:finished];
            }];
        } onStart:^(CAAnimation *anim) {} onDidStop:^(CAAnimation *anim, BOOL finished) {
            if(finished)
            {
                [completed addObject:anim];
            }
            else
            {
                [failed addObject:anim];
            }
        }];
        
        return [[ANYActivity activityWithTearDownBlock:^{
            
            for(ANYCoreAnimationChange *change in added)
            {
                BOOL cancelledViaActivity = ![failed containsObject:change.animation] && ![completed containsObject:change.animation];
                
                if(cancelledViaActivity)
                {
                    [self applyValueOfPresentationLayer:change.layer animation:change.animation];
                    
                    if(change.key)
                    {
                        [change.layer removeAnimationForKey:change.key];
                    }
                }
            }
            
        }] nameFormat:@"(UIView, duration: %.2f, delay: %.2f)", duration, delay];
        
    }];
}

+ (void)applyValueOfPresentationLayer:(CALayer *)layer animation:(CAAnimation *)animation
{
    if([animation isKindOfClass:[CAPropertyAnimation class]])
    {
        CAPropertyAnimation *propertyAnim = (id)animation;
        id value = [layer.presentationLayer valueForKeyPath:propertyAnim.keyPath];
        [layer setValue:value forKey:propertyAnim.keyPath];
    }
}

@end
