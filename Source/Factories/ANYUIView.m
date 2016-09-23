//
//  ANYUIKit.m
//  Anymotion
//
//  Created by Håvard Fossli on 12.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

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
