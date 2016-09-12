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
#import "ANYEXTScope.h"

@interface ANYSpringPOP ()
@property (nonatomic, copy) void (^configure)(POPSpringAnimation *anim);
@end

@implementation ANYSpringPOP

- (ANYSpringPOP *)configure:(void (^)(POPSpringAnimation *anim))configure
{
    ANYSpringPOP *instance = [ANYSpringPOP new];
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

- (id)copyWithZone:(NSZone *)zone
{
    return [self configure:nil];
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

- (ANYAnimation *)animationFor:(NSObject *)object propertyNamed:(NSString *)name
{
    return [self animationFor:object property:[POPAnimatableProperty propertyWithName:name]];
}

- (ANYAnimation *)animationFor:(NSObject *)object property:(POPAnimatableProperty *)property
{
    NSString *key = [NSString stringWithFormat:@"ag.%@", property.name];
    
    @weakify(object);
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        @strongify(object);
        
        POPSpringAnimation *basic = [self build];
        basic.completionBlock = ^(POPAnimation *anim, BOOL completed) {
            [subscriber completed:completed];
        };
        
        [object pop_removeAnimationForKey:key];
        [object pop_addAnimation:basic forKey:key];
        
        return [ANYActivity activityWithBlock:^{
            
            @strongify(object);
            [object pop_removeAnimationForKey:key];
            
        }];
        
    }];
}

@end
