//
//  ANYUIKit.m
//  Anymotion
//
//  Created by Håvard Fossli on 12.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "ANYUIView.h"
#import <UIKit/UIKit.h>

@interface ANYUIView ()
@property (nonatomic, copy) void (^block)(void);
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSTimeInterval delay;
@property (nonatomic, assign) UIViewAnimationOptions options;
@end

@implementation ANYUIView

- (ANYUIView *)block:(void (^)(void))block
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

- (ANYAnimation *)animation
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        
        [UIView animateWithDuration:self.duration delay:self.delay options:self.options animations:^{
            self.block();
        } completion:^(BOOL finished) {
            [subscriber completed:finished];
        }];
        
        return [ANYActivity activityWithTearDownBlock:^{
           // TODO: Can we know which views properties to cancel?
        }];
    }];
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
        
        [UIView animateWithDuration:0 delay:0 options:0 animations:^{
            block();
        } completion:^(BOOL finished) {
            [subscriber completed:finished];
        }];
        
        return [ANYActivity activityWithTearDownBlock:^{
            // TODO: Can we know which views properties to cancel?
        }];
    }];
}

@end
