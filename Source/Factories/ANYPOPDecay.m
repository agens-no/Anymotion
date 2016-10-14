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

#import "ANYPOPDecay.h"
#import "ANYEXTScope.h"
#import "ANYPOPMemoryTable.h"

@interface ANYPOPDecay ()
@property (nonatomic, copy) void (^configure)(POPDecayAnimation *anim);
@end

@implementation ANYPOPDecay

+ (instancetype)propertyNamed:(NSString *)name
{
    return [self property:[POPAnimatableProperty propertyWithName:name]];
}

+ (instancetype)property:(POPAnimatableProperty *)property
{
    return [[self new] configure:^(POPDecayAnimation *anim) {
        anim.property = property;
    }];
}

- (instancetype)configure:(void (^)(POPDecayAnimation *anim))configure
{
    ANYPOPDecay *instance = [ANYPOPDecay new];
    instance.configure = ^(POPDecayAnimation *basic){
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

- (POPDecayAnimation *)build
{
    POPDecayAnimation *anim = [POPDecayAnimation animation];
    self.configure(anim);
    return anim;
}

- (instancetype)fromValue:(id)fromValue
{
    return [self configure:^(POPDecayAnimation *anim) {
        anim.fromValue = fromValue;
    }];
}

- (instancetype)beginTime:(CFTimeInterval)beginTime
{
    return [self configure:^(POPDecayAnimation *anim) {
        anim.beginTime = beginTime;
    }];
}

- (instancetype)velocity:(id)velocity
{
    return [self configure:^(POPDecayAnimation *anim) {
        anim.velocity = velocity;
    }];
}

- (instancetype)deceleration:(CGFloat)deceleration
{
    return [self configure:^(POPDecayAnimation *anim) {
        anim.deceleration = deceleration;
    }];
}

+ (ANYPOPMemoryTable <POPDecayAnimation *> *)sharedTable
{
    static ANYPOPMemoryTable <POPDecayAnimation *> *instance;
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
        
        POPDecayAnimation *anim = [self build];
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
            
        }] nameFormat:@"(pop.decay key: '%@', toValue: %@, object: <%@ %p>)", key, anim.toValue, object.class, object];
        
    }];
}

@end


@implementation ANYPOPDecay (Convenience)

+ (POPDecayAnimation *)lastActiveAnimationForPropertyNamed:(NSString *)name object:(NSObject *)object
{
    return [self lastActiveAnimationForProperty:[POPAnimatableProperty propertyWithName:name] object:object];
}

+ (POPDecayAnimation *)lastActiveAnimationForProperty:(POPAnimatableProperty *)property object:(NSObject *)object
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

@end
