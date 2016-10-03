//
//  ANYUIKit.h
//  Anymotion
//
//  Created by Håvard Fossli on 12.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <pop/pop.h>
#import "ANYAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANYUIView : NSObject

- (instancetype)duration:(NSTimeInterval)duration;
- (instancetype)delay:(NSTimeInterval)delay;
- (instancetype)options:(UIViewAnimationOptions)options;
- (instancetype)addOptions:(UIViewAnimationOptions)options;
- (instancetype)block:(void (^)(void))block;

@end


/*
 If the animation is cancelled we will
 - remove the underlying core animation
 - leave the view in its current presented state.
 
 We're acheiving this by looking at
 - which animations have been added to the view/layer
 - what's the current value on the layer.presentationLayer for those animations
 */

@interface ANYUIView (Clean)

- (ANYAnimation *)animation;

+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration block:(void(^)(void))block;
+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options block:(void(^)(void))block;
+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay block:(void(^)(void))block;
+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options block:(void(^)(void))block;

@end


/*
 Use this if you don't want to remove the underlying Core Animations on cancellation.
 */

@interface ANYUIView (NoClean)

- (ANYAnimation *)noCleanAnimation;

+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration block:(void(^)(void))block;
+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options block:(void(^)(void))block;
+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay block:(void(^)(void))block;
+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options block:(void(^)(void))block;

@end

NS_ASSUME_NONNULL_END
