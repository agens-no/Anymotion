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

@interface ANYUIView : NSObject <NSCopying>

- (ANYUIView *)block:(void (^)(void))block;

- (instancetype)duration:(NSTimeInterval)duration;
- (instancetype)delay:(NSTimeInterval)delay;
- (instancetype)options:(UIViewAnimationOptions)options;

- (instancetype)addOptions:(UIViewAnimationOptions)options;

- (ANYAnimation *)animation;

+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration block:(void(^)(void))block;
+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options block:(void(^)(void))block;
+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay block:(void(^)(void))block;
+ (ANYAnimation *)animationWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options block:(void(^)(void))block;


@end
