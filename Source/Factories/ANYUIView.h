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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <pop/pop.h>
#import "ANYAnimation.h"

NS_ASSUME_NONNULL_BEGIN

@interface ANYUIView : NSObject

+ (instancetype)duration:(NSTimeInterval)duration;
+ (instancetype)delay:(NSTimeInterval)delay;
+ (instancetype)options:(UIViewAnimationOptions)options;
+ (instancetype)block:(void (^)(void))block;

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

+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration block:(void(^)(void))block NS_SWIFT_UNAVAILABLE("");
+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options block:(void(^)(void))block NS_SWIFT_NAME(animation(duration:options:block:));
+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay block:(void(^)(void))block NS_SWIFT_UNAVAILABLE("");
+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options block:(void(^)(void))block NS_SWIFT_NAME(animation(duration:delay:options:block:));

@end


/*
 Use this if you don't want to remove the underlying Core Animations on cancellation.
 */

@interface ANYUIView (NoClean)

- (ANYAnimation *)noCleanAnimation;

+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration block:(void(^)(void))block NS_SWIFT_UNAVAILABLE("");
+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options block:(void(^)(void))block NS_SWIFT_NAME(noCleanAnimation(duration:options:block:));;
+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay block:(void(^)(void))block NS_SWIFT_UNAVAILABLE("");
+ (ANYAnimation *)noCleanAnimationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options block:(void(^)(void))block NS_SWIFT_NAME(noCleanAnimation(duration:delay:options:block:));;

@end

NS_ASSUME_NONNULL_END
