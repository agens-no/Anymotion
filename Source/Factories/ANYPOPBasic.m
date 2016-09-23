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

#import "ANYPOPBasic.h"
#import "ANYEXTScope.h"
#import "ANYPOPMemoryTable.h"

@interface ANYPOPBasic () <NSCopying>
@property (nonatomic, copy) void (^configure)(POPBasicAnimation *anim);
@end

@implementation ANYPOPBasic

+ (instancetype)propertyNamed:(NSString *)name
{
    return [self property:[POPAnimatableProperty propertyWithName:name]];
}

+ (instancetype)property:(POPAnimatableProperty *)property
{
    return [[self new] configure:^(POPBasicAnimation *anim) {
        anim.property = property;
    }];
}

- (ANYPOPBasic *)configure:(void (^)(POPBasicAnimation *anim))configure
{
    ANYPOPBasic *instance = [ANYPOPBasic new];
    instance.configure = ^(POPBasicAnimation *basic){
        if(self.configure)
        {
            self.configure(basic);
        }
        if(configure)
        {
            configure(basic);
        }
    };
    return instance;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self configure:nil];
}

- (POPBasicAnimation *)build
{
    POPBasicAnimation *anim = [POPBasicAnimation animation];
    self.configure(anim);
    return anim;
}

- (instancetype)fromValue:(id)fromValue
{
    return [self configure:^(POPBasicAnimation *anim) {
        anim.fromValue = fromValue;
    }];
}

- (instancetype)toValue:(id)toValue
{
    return [self configure:^(POPBasicAnimation *anim) {
        anim.toValue = toValue;
    }];
}

- (instancetype)duration:(NSTimeInterval)duration
{
    return [self configure:^(POPBasicAnimation *anim) {
        anim.duration = duration;
    }];
}

- (instancetype)timingFunction:(CAMediaTimingFunction *)timingFunction
{
    return [self configure:^(POPBasicAnimation *anim) {
        anim.timingFunction = timingFunction;
    }];
}

+ (ANYPOPMemoryTable <POPBasicAnimation *> *)sharedTable
{
    static ANYPOPMemoryTable <POPBasicAnimation *> *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [ANYPOPMemoryTable new];
    });
    return instance;
}

- (ANYAnimation *)animationFor:(NSObject *)object
{
    @weakify(object);
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        @strongify(object);
        
        POPBasicAnimation *anim = [self build];
        NSAssert(anim.property, @"No property specified for animation %@", anim);
        NSString *key = [NSString stringWithFormat:@"any.%@", anim.property.name];
        
        anim.completionBlock = ^(POPAnimation *anim, BOOL completed) {
            [subscriber completed:completed];
        };
        
        [object pop_removeAnimationForKey:key];
        [object pop_addAnimation:anim forKey:key];
        [[self.class sharedTable] setAnimation:anim forProperty:anim.property object:object];
        
        return [[ANYActivity activityWithTearDownBlock:^{
            
            @strongify(object);
            [object pop_removeAnimationForKey:key];
            
        }] nameFormat:@"(pop.basic key: '%@', toValue: %@, object: <%@ %p>)", key, anim.toValue, object.class, object];
        
    }];
}


@end

@implementation ANYPOPBasic (Convenience)

+ (POPSpringAnimation *)lastActiveAnimationForPropertyNamed:(NSString *)name object:(NSObject *)object
{
    return [self lastActiveAnimationForProperty:[POPAnimatableProperty propertyWithName:name] object:object];
}

+ (POPSpringAnimation *)lastActiveAnimationForProperty:(POPAnimatableProperty *)property object:(NSObject *)object
{
    return [[self sharedTable] animationForProperty:property object:object];
}

- (instancetype)fromValueWithPoint:(CGPoint)point
{
    return [self fromValue:[NSValue valueWithCGPoint:point]];
}

- (instancetype)fromValueWithSize:(CGSize)size
{
    return [self fromValue:[NSValue valueWithCGSize:size]];
}

- (instancetype)fromValueWithRect:(CGRect)rect
{
    return [self fromValue:[NSValue valueWithCGRect:rect]];
}

- (instancetype)toValueWithPoint:(CGPoint)point
{
    return [self toValue:[NSValue valueWithCGPoint:point]];
}

- (instancetype)toValueWithSize:(CGSize)size
{
    return [self toValue:[NSValue valueWithCGSize:size]];
}

- (instancetype)toValueWithRect:(CGRect)rect
{
    return [self toValue:[NSValue valueWithCGRect:rect]];
}

@end
