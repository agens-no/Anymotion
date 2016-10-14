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

#import "ANYAnimation.h"
#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ANYCAKeyframe : NSObject

+ (instancetype)keyPath:(NSString *)keyPath;

- (instancetype)values:(nullable NSArray *)values;
- (instancetype)path:(nullable UIBezierPath *)path;
- (instancetype)keyTimes:(nullable NSArray <NSNumber *> *)keyTimes;
- (instancetype)timingFunctions:(nullable NSArray <CAMediaTimingFunction *> *)timingFunctions;
- (instancetype)calculationMode:(NSString *)calculationMode;
- (instancetype)tensionValues:(nullable NSArray <NSNumber *> *)tensionValues;
- (instancetype)continuityValues:(nullable NSArray <NSNumber *> *)continuityValues;
- (instancetype)biasValues:(nullable NSArray <NSNumber *> *)biasValues;
- (instancetype)rotationMode:(nullable NSString *)rotationMode;
- (instancetype)duration:(NSTimeInterval)duration;
- (instancetype)additive:(BOOL)additive;

- (ANYAnimation *)animationFor:(CALayer *)layer;

@end

@interface ANYCAKeyframe (Convenience)

- (instancetype)updateModel;

@end

NS_ASSUME_NONNULL_END
