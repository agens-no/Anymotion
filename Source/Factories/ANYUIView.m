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

@interface ANYUIView () <NSCopying>
@property (nonatomic, copy) void (^block)(void);
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) UIViewAnimationOptions options;
@end

@implementation ANYUIView

+ (instancetype)duration:(NSTimeInterval)duration
{
    return [[self new] duration:duration];
}

+ (instancetype)delay:(NSTimeInterval)delay
{
    return [[self new] delay:delay];
}

+ (instancetype)options:(UIViewAnimationOptions)options
{
    return [[self new] options:options];
}

+ (instancetype)block:(void (^)(void))block
{
    return [[self new] block:block];
}

- (id)copyWithZone:(NSZone *)zone
{
    ANYUIView *copy = [ANYUIView new];
    copy.block = self.block;
    copy.duration = self.duration;
    copy.delay = self.delay;
    copy.options = self.options;
    return copy;
}

- (instancetype)duration:(NSTimeInterval)duration
{
    ANYUIView *copy = [self copy];
    copy.duration = duration;
    return copy;
}

- (instancetype)delay:(NSTimeInterval)delay
{
    ANYUIView *copy = [self copy];
    copy.delay = delay;
    return copy;
}

- (instancetype)options:(UIViewAnimationOptions)options
{
    ANYUIView *copy = [self copy];
    copy.options = options;
    return copy;
}

- (instancetype)addOptions:(UIViewAnimationOptions)options
{
    ANYUIView *copy = [self copy];
    copy.options = self.options | options;
    return copy;
}

- (instancetype)block:(void (^)(void))block
{
    ANYUIView *instance = [self copy];
    instance.block = ^{
        if(self.block)
        {
            self.block();
        }
        if(block)
        {
            block();
        }
    };
    return instance;
}

@end


@implementation ANYUIView (Clean)

- (ANYAnimation *)animation
{
    return [self.class animationWithDuration:self.duration delay:self.delay options:self.options block:self.block];
}

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
        
        NSMapTable <CALayer *, ANYCoreAnimationChanges *> *added = [[ANYCoreAnimationObserver shared] addedAnimations:^{
            [UIView animateWithDuration:duration delay:delay options:options animations:^{
                block();
            } completion:^(BOOL finished) {
                [subscriber completed:finished];
            }];
        }];
        
        return [[ANYActivity activityWithTearDownBlock:^{
            
            [self removeAddedAnimation:added];
            
        }] nameFormat:@"(UIView, clean, duration: %.2f, delay: %.2f)", duration, delay];
        
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

+ (void)removeAddedAnimation:(NSMapTable <CALayer *, ANYCoreAnimationChanges *> *)added
{
    for(CALayer *layer in added)
    {
        ANYCoreAnimationChanges *addedToLayer = [added objectForKey:layer];
        
        for(NSString *key in addedToLayer.animationsWithKeys)
        {
            [layer removeAnimationForKey:key];
            
            CAAnimation *animation = addedToLayer.animationsWithKeys[key];
            [self applyValueOfPresentationLayer:layer animation:animation];
        }
        
        for(CAAnimation *animation in addedToLayer.animationsWithoutKeys)
        {
            [self applyValueOfPresentationLayer:layer animation:animation];
        }
    }
}

@end

@implementation ANYUIView (NoClean)

- (ANYAnimation *)noCleanAnimation
{
    return [self.class animationWithDuration:self.duration delay:self.delay options:self.options block:self.block];
}

+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration block:(void(^)(void))block
{
    return [self noCleanAnimationWithDuration:duration delay:0 options:0 block:block];
}

+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options block:(void(^)(void))block
{
    return [self noCleanAnimationWithDuration:duration delay:0 options:options block:block];
}

+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay block:(void(^)(void))block
{
    return [self noCleanAnimationWithDuration:duration delay:delay options:0 block:block];
}

+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options block:(void(^)(void))block
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        
        [UIView animateWithDuration:duration delay:delay options:options animations:^{
            block();
        } completion:^(BOOL finished) {
            [subscriber completed:finished];
        }];
        
        return [[ANYActivity new] nameFormat:@"(UIView, no clean, duration: %.2f, delay: %.2f)", duration, delay];
        
    }];
}

@end
