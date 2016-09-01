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

#import "ANYSpringPOP.h"
#import "POPAnimation+ANYAnimation.h"

@interface ANYSpringPOP ()

@property (nonatomic, strong) POPAnimatableProperty *property;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;
@property (nonatomic, assign) CFTimeInterval beginTime;
@property (nonatomic, assign) id velocity;
@property (nonatomic, assign) CGFloat springSpeed;
@property (nonatomic, assign) CGFloat dynamicsMass;
@property (nonatomic, assign) CGFloat dynamicsTension;
@property (nonatomic, assign) CGFloat dynamicsFriction;
@property (nonatomic, assign) CGFloat springBounciness;

@end

@implementation ANYSpringPOP

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        POPSpringAnimation *anim = [POPSpringAnimation animation];
        self.fromValue = anim.fromValue;
        self.toValue = anim.toValue;
        self.beginTime = anim.beginTime;
        self.velocity = anim.velocity;
        self.springSpeed = anim.springSpeed;
        self.dynamicsMass = anim.dynamicsMass;
        self.dynamicsTension = anim.dynamicsTension;
        self.dynamicsFriction = anim.dynamicsFriction;
        self.springBounciness = anim.springBounciness;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ANYSpringPOP *factory = [ANYSpringPOP new];
    factory.property = self.property;
    factory.fromValue = self.fromValue;
    factory.toValue = self.toValue;
    factory.beginTime = self.beginTime;
    factory.velocity = self.velocity;
    factory.springSpeed = self.springSpeed;
    factory.dynamicsMass = self.dynamicsMass;
    factory.dynamicsTension = self.dynamicsTension;
    factory.dynamicsFriction = self.dynamicsFriction;
    factory.springBounciness = self.springBounciness;
    return factory;
}

- (instancetype)propertyNamed:(NSString *)property
{
    ANYSpringPOP *factory = [self copy];
    factory.property = [POPAnimatableProperty propertyWithName:property];
    return factory;
}

+ (instancetype)propertyNamed:(NSString *)property
{
    ANYSpringPOP *factory = [self new];
    factory.property = [POPAnimatableProperty propertyWithName:property];
    return factory;
}

- (instancetype)property:(POPAnimatableProperty *)property
{
    ANYSpringPOP *factory = [self copy];
    factory.property = property;
    return factory;
}

+ (instancetype)property:(POPAnimatableProperty *)property
{
    ANYSpringPOP *factory = [self new];
    factory.property = property;
    return factory;
}

- (instancetype)fromValue:(id)fromValue
{
    ANYSpringPOP *factory = [self copy];
    factory.fromValue = fromValue;
    return factory;
}

- (instancetype)toValue:(id)toValue
{
    ANYSpringPOP *factory = [self copy];
    factory.toValue = toValue;
    return factory;
}

- (instancetype)beginTime:(CFTimeInterval)beginTime
{
    ANYSpringPOP *factory = [self copy];
    factory.beginTime = beginTime;
    return factory;
}

- (instancetype)velocity:(id)velocity
{
    ANYSpringPOP *factory = [self copy];
    factory.velocity = velocity;
    return factory;
}

- (instancetype)springSpeed:(CGFloat)springSpeed
{
    ANYSpringPOP *factory = [self copy];
    factory.springSpeed = springSpeed;
    return factory;
}

- (instancetype)dynamicsMass:(CGFloat)dynamicsMass
{
    ANYSpringPOP *factory = [self copy];
    factory.dynamicsMass = dynamicsMass;
    return factory;
}

- (instancetype)dynamicsTension:(CGFloat)dynamicsTension
{
    ANYSpringPOP *factory = [self copy];
    factory.dynamicsTension = dynamicsTension;
    return factory;
}

- (instancetype)dynamicsFriction:(CGFloat)dynamicsFriction
{
    ANYSpringPOP *factory = [self copy];
    factory.dynamicsFriction = dynamicsFriction;
    return factory;
}

- (instancetype)springBounciness:(CGFloat)springBounciness
{
    ANYSpringPOP *factory = [self copy];
    factory.springBounciness = springBounciness;
    return factory;
}

- (id)buildAnimation
{
    POPSpringAnimation *anim = [POPSpringAnimation new];
    anim.property = self.property;
    anim.fromValue = self.fromValue;
    anim.toValue = self.toValue;
    anim.beginTime = self.beginTime;
    anim.velocity = self.velocity;
    anim.springSpeed = self.springSpeed;
    anim.dynamicsMass = self.dynamicsMass;
    anim.dynamicsTension = self.dynamicsTension;
    anim.dynamicsFriction = self.dynamicsFriction;
    anim.springBounciness = self.springBounciness;
    return anim;
}

- (ANYAnimation *)animation:(NSObject *)object
{
    return [[self build] animation:object];
}

@end
