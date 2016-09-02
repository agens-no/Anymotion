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
#import "CoreAnimation+ANYAnimation.h"

#import <QuartzCore/QuartzCore.h>

@interface ANYBasicCoreAnimation ()

@property (nonatomic, strong) NSString *keyPath;
@property (nonatomic, strong) id toValue;
@property (nonatomic, strong) id byValue;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, assign) BOOL additive;
@property (nonatomic, assign) BOOL cumulative;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) BOOL removedOnCompletion;
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

@end

@implementation ANYBasicCoreAnimation

- (id)copyWithZone:(NSZone *)zone
{
    ANYBasicCoreAnimation *factory = [ANYBasicCoreAnimation new];
    factory.keyPath = self.keyPath;
    factory.toValue = self.toValue;
    factory.byValue = self.byValue;
    factory.fromValue = self.fromValue;
    factory.additive = self.additive;
    factory.cumulative = self.cumulative;
    factory.duration = self.duration;
    factory.removedOnCompletion = self.removedOnCompletion;
    factory.timingFunction = self.timingFunction;
    return factory;
}

+ (instancetype)animationWithKeyPath:(NSString *)keyPath;
{
    ANYBasicCoreAnimation *factory = [self new];
    factory.keyPath = keyPath;
    return factory;
}

- (instancetype)animationWithKeyPath:(NSString *)keyPath;
{
    ANYBasicCoreAnimation *factory = [self copy];
    factory.keyPath = keyPath;
    return factory;
}

- (instancetype)toValue:(id)toValue
{
    ANYBasicCoreAnimation *factory = [self copy];
    factory.toValue = toValue;
    return factory;
}

- (instancetype)byValue:(id)byValue
{
    ANYBasicCoreAnimation *factory = [self copy];
    factory.byValue = byValue;
    return factory;
}

- (instancetype)fromValue:(id)fromValue
{
    ANYBasicCoreAnimation *factory = [self copy];
    factory.fromValue = fromValue;
    return factory;
}

- (instancetype)additive:(BOOL)additive
{
    ANYBasicCoreAnimation *factory = [self copy];
    factory.additive = additive;
    return factory;
}

- (instancetype)cumulative:(BOOL)cumulative
{
    ANYBasicCoreAnimation *factory = [self copy];
    factory.cumulative = cumulative;
    return factory;
}

- (instancetype)duration:(NSTimeInterval)duration
{
    ANYBasicCoreAnimation *factory = [self copy];
    factory.duration = duration;
    return factory;
}

- (instancetype)removedOnCompletion:(BOOL)removedOnCompletion
{
    ANYBasicCoreAnimation *factory = [self copy];
    factory.removedOnCompletion = removedOnCompletion;
    return factory;
}

- (instancetype)timingFunction:(CAMediaTimingFunction *)timingFunction
{
    ANYBasicCoreAnimation *factory = [self copy];
    factory.timingFunction = timingFunction;
    return factory;
}

- (CABasicAnimation *)build
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = self.keyPath;
    anim.toValue = self.toValue;
    anim.byValue = self.byValue;
    anim.fromValue = self.fromValue;
    anim.additive = self.additive;
    anim.cumulative = self.cumulative;
    anim.duration = self.duration;
    anim.removedOnCompletion = self.removedOnCompletion;
    anim.timingFunction = self.timingFunction;
    return anim;
}

- (ANYAnimation *)animation:(CALayer *)layer
{
    return [[self build] animation:layer];
}

@end
