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

#import "ANYBasicPOP.h"
#import "POPAnimation+ANYAnimation.h"

@interface ANYBasicPOP ()

@property (nonatomic, strong) POPAnimatableProperty *property;
@property (nonatomic, strong) id fromValue;
@property (nonatomic, strong) id toValue;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) CAMediaTimingFunction *timingFunction;

@end

@implementation ANYBasicPOP

- (id)copyWithZone:(NSZone *)zone
{
    ANYBasicPOP *factory = [ANYBasicPOP new];
    factory.property = self.property;
    factory.fromValue = self.fromValue;
    factory.toValue = self.toValue;
    factory.duration = self.duration;
    factory.timingFunction = self.timingFunction;
    return factory;
}

+ (instancetype)propertyNamed:(NSString *)property
{
    ANYBasicPOP *factory = [self new];
    factory.property = [POPAnimatableProperty propertyWithName:property];
    return factory;
}

+ (instancetype)property:(POPAnimatableProperty *)property
{
    ANYBasicPOP *factory = [self new];
    factory.property = property;
    return factory;
}

- (instancetype)propertyNamed:(NSString *)property
{
    ANYBasicPOP *factory = [self copy];
    factory.property = [POPAnimatableProperty propertyWithName:property];
    return factory;
}

- (instancetype)property:(POPAnimatableProperty *)property
{
    ANYBasicPOP *factory = [self copy];
    factory.property = property;
    return factory;
}

- (instancetype)fromValue:(id)fromValue
{
    ANYBasicPOP *factory = [self copy];
    factory.fromValue = fromValue;
    return factory;
}

- (instancetype)toValue:(id)toValue
{
    ANYBasicPOP *factory = [self copy];
    factory.toValue = toValue;
    return factory;
}

- (instancetype)duration:(NSTimeInterval)duration
{
    ANYBasicPOP *factory = [self copy];
    factory.duration = duration;
    return factory;
}

- (instancetype)timingFunction:(CAMediaTimingFunction *)timingFunction
{
    ANYBasicPOP *factory = [self copy];
    factory.timingFunction = timingFunction;
    return factory;
}

- (POPBasicAnimation *)build
{
    POPBasicAnimation *anim = [POPBasicAnimation new];
    anim.property = self.property;
    anim.fromValue = self.fromValue;
    anim.toValue = self.toValue;
    anim.duration = self.duration;
    anim.timingFunction = self.timingFunction;
    return anim;
}

- (ANYAnimation *)animation:(NSObject *)object
{
    return [[self build] animation:object];
}

@end
