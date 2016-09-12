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

#import "ANYBasicCoreAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import "ANYEXTScope.h"
#import "ANYCALayerAnimationBlockDelegate.h"


@interface ANYBasicCoreAnimation ()
@property (nonatomic, copy) void (^configure)(CABasicAnimation *anim);
@end

@implementation ANYBasicCoreAnimation

- (ANYBasicCoreAnimation *)configure:(void (^)(CABasicAnimation *anim))configure
{
    ANYBasicCoreAnimation *instance = [ANYBasicCoreAnimation new];
    instance.configure = ^(CABasicAnimation *basic){
        if(self.configure)
        {
            self.configure(basic);
        }
        if(configure)
        {
            configure(basic);
        }
    };
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self configure:nil];
}

- (CABasicAnimation *)build
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    self.configure(anim);
    return anim;
}

- (instancetype)toValue:(id)toValue
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.toValue = toValue;
    }];
}

- (instancetype)byValue:(id)byValue
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.byValue = byValue;
    }];
}

- (instancetype)fromValue:(id)fromValue
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.fromValue = fromValue;
    }];
}

- (instancetype)additive:(BOOL)additive
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.additive = additive;
    }];
}

- (instancetype)cumulative:(BOOL)cumulative
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.cumulative = cumulative;
    }];
}

- (instancetype)duration:(NSTimeInterval)duration
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.duration = duration;
    }];
}

- (instancetype)removedOnCompletion:(BOOL)removedOnCompletion
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.removedOnCompletion = removedOnCompletion;
    }];
}

- (instancetype)timingFunction:(CAMediaTimingFunction *)timingFunction
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.timingFunction = timingFunction;
    }];
}

- (ANYAnimation *)animationFor:(CALayer *)layer keyPath:(NSString *)keyPath
{
    NSString *key = [NSString stringWithFormat:@"ag.%@", keyPath];
    
    @weakify(layer);
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        @strongify(layer);
        
        CABasicAnimation *basic = [self build];
        basic.delegate = [ANYCALayerAnimationBlockDelegate newWithAnimationDidStop:^(BOOL completed){
            if(completed)
            {
                [subscriber completed];
            }
            else
            {
                [subscriber failed];
            }
        }];
        
        [layer removeAnimationForKey:key];
        [layer addAnimation:basic forKey:key];
        
        return [ANYActivity activityWithTearDownBlock:^{
            
            @strongify(layer);
            [layer removeAnimationForKey:key];
            
        }];
        
    }];
}

@end
