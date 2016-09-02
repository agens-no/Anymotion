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

#import "CoreAnimation+ANYAnimation.h"
#import "ANYEXTScope.h"
#import "AGKCALayerAnimationBlockDelegate.H"

#import <UIKit/UIKit.h>

@implementation CABasicAnimation (ANYAnimation)

- (ANYAnimation *)animation:(CALayer *)layer resetBlock:(void(^)(void))reset
{
    NSString *key = [NSString stringWithFormat:@"ag.%@", self.keyPath];
    
    @weakify(layer);
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        
        @strongify(layer);
        
        reset();
        
        CAAnimation *anim = [layer animationForKey:key];
        if (anim == nil || anim != self)
        {
            [layer addAnimation:self forKey:key];
        }
        
        AGKCALayerAnimationBlockDelegate *delegate;
        if ([anim.delegate isKindOfClass:[AGKCALayerAnimationBlockDelegate class]])
        {
            delegate = (AGKCALayerAnimationBlockDelegate *)anim.delegate;
        }
        else
        {
            delegate = [AGKCALayerAnimationBlockDelegate newWithAnimationDidStop:^(BOOL completed){}];
            self.delegate = delegate;
        }
        
        void (^oldCompletion)(BOOL) = delegate.onStop;
        void (^completionBlock)(BOOL) = ^(BOOL success){
            if(success)
            {
                [subscriber completed];
            }
            else
            {
                [subscriber failed];
            }
        };
        
        delegate.onStop = ^(BOOL success) {
            oldCompletion(success);
            completionBlock(success);
        };
        
        return [ANYActivity activityWithBlock:^{
            
            @strongify(layer);
            [layer removeAnimationForKey:key];
            
        }];
        
    }];
}

- (ANYAnimation *)animation:(CALayer *)layer toValue:(id)toValue
{
    @weakify(self);
    return [self animation:layer resetBlock:^{
        @strongify(self);
        self.toValue = toValue;
    }];
}

- (ANYAnimation *)animation:(CALayer *)layer
{
    return [self animation:layer toValue:self.toValue];
}

@end
