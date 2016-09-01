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

#import "ANYDecayPOP.h"
#import "POPAnimation+ANYAnimation.h"

@interface ANYDecayPOP ()

@property (nonatomic, strong) POPAnimatableProperty *property;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, assign) CFTimeInterval beginTime;
@property (nonatomic, assign) id velocity;
@property (nonatomic, assign) CGFloat deceleration;

@end

@implementation ANYDecayPOP

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        POPDecayAnimation *anim = [POPDecayAnimation animation];
        self.fromValue = anim.fromValue;
        self.beginTime = anim.beginTime;
        self.velocity = anim.velocity;
        self.deceleration = anim.deceleration;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ANYDecayPOP *factory = [ANYDecayPOP new];
    factory.property = self.property;
    factory.fromValue = self.fromValue;
    factory.beginTime = self.beginTime;
    factory.velocity = self.velocity;
    factory.deceleration = self.deceleration;
    return factory;
}

- (instancetype)propertyNamed:(NSString *)property
{
    ANYDecayPOP *factory = [self copy];
    factory.property = [POPAnimatableProperty propertyWithName:property];
    return factory;
}

+ (instancetype)propertyNamed:(NSString *)property
{
    ANYDecayPOP *factory = [self new];
    factory.property = [POPAnimatableProperty propertyWithName:property];
    return factory;
}

- (instancetype)property:(POPAnimatableProperty *)property
{
    ANYDecayPOP *factory = [self copy];
    factory.property = property;
    return factory;
}

+ (instancetype)property:(POPAnimatableProperty *)property
{
    ANYDecayPOP *factory = [self new];
    factory.property = property;
    return factory;
}

- (instancetype)fromValue:(id)fromValue;
{
    ANYDecayPOP *factory = [self copy];
    factory.fromValue = fromValue;
    return factory;
}

- (instancetype)beginTime:(CFTimeInterval)beginTime
{
    ANYDecayPOP *factory = [self copy];
    factory.beginTime = beginTime;
    return factory;
}

- (instancetype)velocity:(id)velocity
{
    ANYDecayPOP *factory = [self copy];
    factory.velocity = velocity;
    return factory;
}

- (instancetype)deceleration:(CGFloat)deceleration
{
    ANYDecayPOP *factory = [self copy];
    factory.deceleration = deceleration;
    return factory;
}

- (POPDecayAnimation *)build
{
    POPDecayAnimation *anim = [POPDecayAnimation new];
    anim.property = self.property;
    anim.fromValue = self.fromValue;
    anim.beginTime = self.beginTime;
    anim.velocity = self.velocity;
    anim.deceleration = self.deceleration;
    return anim;
}

- (ANYAnimation *)animation:(NSObject *)object
{
    return [[self build] animation:object];
}

@end
