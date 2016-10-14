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

#import "ANYPOPSpring.h"
#import "ANYEXTScope.h"
#import "ANYPOPMemoryTable.h"

@interface ANYPOPSpring ()
@property (nonatomic, copy) void (^configure)(POPSpringAnimation *anim);
@end

@implementation ANYPOPSpring

+ (instancetype)propertyNamed:(NSString *)name
{
    return [self property:[POPAnimatableProperty propertyWithName:name]];
}

+ (instancetype)property:(POPAnimatableProperty *)property
{
    return [[self new] configure:^(POPSpringAnimation *anim) {
        anim.property = property;
    }];
}

- (POPSpringAnimation *)build
{
    POPSpringAnimation *anim = [POPSpringAnimation animation];
    self.configure(anim);
    return anim;
}

- (instancetype)fromValue:(id)fromValue
{
    return [self configure:^(POPSpringAnimation *anim) {
        anim.fromValue = fromValue;
    }];
}

- (instancetype)toValue:(id)toValue
{
    return [self configure:^(POPSpringAnimation *anim) {
        anim.toValue = toValue;
    }];
}

- (instancetype)beginTime:(CFTimeInterval)beginTime
{
    return [self configure:^(POPSpringAnimation *anim) {
        anim.beginTime = beginTime;
    }];
}

- (instancetype)velocity:(id)velocity
{
    return [self configure:^(POPSpringAnimation *anim) {
        anim.velocity = velocity;
    }];
}

- (instancetype)springSpeed:(CGFloat)springSpeed
{
    return [self configure:^(POPSpringAnimation *anim) {
        anim.springSpeed = springSpeed;
    }];
}

- (instancetype)dynamicsMass:(CGFloat)dynamicsMass
{
    return [self configure:^(POPSpringAnimation *anim) {
        anim.dynamicsMass = dynamicsMass;
    }];
}

- (instancetype)dynamicsTension:(CGFloat)dynamicsTension
{
    return [self configure:^(POPSpringAnimation *anim) {
        anim.dynamicsTension = dynamicsTension;
    }];
}

- (instancetype)dynamicsFriction:(CGFloat)dynamicsFriction
{
    return [self configure:^(POPSpringAnimation *anim) {
        anim.dynamicsFriction = dynamicsFriction;
    }];
}

- (instancetype)springBounciness:(CGFloat)springBounciness
{
    return [self configure:^(POPSpringAnimation *anim) {
        anim.springBounciness = springBounciness;
    }];
}

- (instancetype)configure:(void (^)(POPSpringAnimation *anim))configure
{
    ANYPOPSpring *instance = [ANYPOPSpring new];
    instance.configure = ^(POPSpringAnimation *basic){
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

+ (ANYPOPMemoryTable <POPSpringAnimation *> *)sharedTable
{
    static ANYPOPMemoryTable <POPSpringAnimation *> *instance;
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
        
        POPSpringAnimation *anim = [self build];
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
            if([object pop_animationForKey:key] == anim)
            {
                [object pop_removeAnimationForKey:key];
            }
            
        }] nameFormat:@"(pop.spring key: '%@', toValue: %@, object: <%@ %p>)", key, anim.toValue, object.class, object];
        
    }];
}

@end


@implementation ANYPOPSpring (Convenience)

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
