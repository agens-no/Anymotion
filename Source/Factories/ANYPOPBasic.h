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

@interface ANYPOPBasic : NSObject

+ (instancetype)propertyNamed:(NSString *)name;
+ (instancetype)property:(POPAnimatableProperty *)property;

- (instancetype)fromValue:(nullable id)fromValue;
- (instancetype)toValue:(nullable id)toValue;
- (instancetype)duration:(NSTimeInterval)duration;
- (instancetype)timingFunction:(nullable CAMediaTimingFunction *)timingFunction;
- (instancetype)configure:(nullable void (^)(POPBasicAnimation *anim))configure;

- (ANYAnimation *)animationFor:(NSObject *)object;

@end

@interface ANYPOPBasic (Convenience)

+ (nullable POPBasicAnimation *)lastActiveAnimationForPropertyNamed:(NSString *)name object:(NSObject *)object;
+ (nullable POPBasicAnimation *)lastActiveAnimationForProperty:(POPAnimatableProperty *)property object:(NSObject *)object;

- (nullable instancetype)fromValueWithPoint:(CGPoint)point;
- (nullable instancetype)fromValueWithSize:(CGSize)size;
- (nullable instancetype)fromValueWithRect:(CGRect)rect;

- (instancetype)toValueWithPoint:(CGPoint)point;
- (instancetype)toValueWithSize:(CGSize)size;
- (instancetype)toValueWithRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
