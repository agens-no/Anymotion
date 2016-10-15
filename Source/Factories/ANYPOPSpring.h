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
#import <pop/pop.h>
#import "ANYAnimation.h"


NS_ASSUME_NONNULL_BEGIN

@interface ANYPOPSpring : NSObject

- (instancetype)initWithPropertyNamed:(NSString *)name NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(_:));
- (instancetype)initWithProperty:(POPAnimatableProperty *)property NS_DESIGNATED_INITIALIZER NS_SWIFT_NAME(init(property:));

+ (instancetype)propertyNamed:(NSString *)name NS_SWIFT_UNAVAILABLE("");
+ (instancetype)property:(POPAnimatableProperty *)property NS_SWIFT_UNAVAILABLE("");

- (instancetype)fromValue:(nullable NSObject *)fromValue;
- (instancetype)toValue:(nullable NSObject *)toValue;
- (instancetype)beginTime:(CFTimeInterval)beginTime;
- (instancetype)velocity:(nullable NSObject *)velocity;
- (instancetype)springSpeed:(CGFloat)springSpeed;
- (instancetype)dynamicsMass:(CGFloat)dynamicsMass;
- (instancetype)dynamicsTension:(CGFloat)dynamicsTension;
- (instancetype)dynamicsFriction:(CGFloat)dynamicsFriction;
- (instancetype)springBounciness:(CGFloat)springBounciness;
- (instancetype)configure:(nullable void (^)(POPSpringAnimation *anim))configure;

- (ANYAnimation *)animationFor:(NSObject *)object;

@end

@interface ANYPOPSpring (Convenience)

+ (nullable POPSpringAnimation *)lastActiveAnimationForPropertyNamed:(NSString *)name object:(NSObject *)object;
+ (nullable POPSpringAnimation *)lastActiveAnimationForProperty:(POPAnimatableProperty *)property object:(NSObject *)object;

- (instancetype)continueWithVelocityInObject:(NSObject *)object;

@end

NS_ASSUME_NONNULL_END
