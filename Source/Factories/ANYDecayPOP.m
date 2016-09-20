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
#import "ANYEXTScope.h"

@interface ANYDecayPOP ()
@property (nonatomic, copy) void (^configure)(POPDecayAnimation *anim);
@end

@implementation ANYDecayPOP

- (ANYDecayPOP *)configure:(void (^)(POPDecayAnimation *anim))configure
{
    ANYDecayPOP *instance = [ANYDecayPOP new];
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

- (id)copyWithZone:(NSZone *)zone
{
    return [self configure:nil];
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
        
        POPDecayAnimation *anim = [self build];
        anim.property = property;
        anim.completionBlock = ^(POPAnimation *anim, BOOL completed) {
            [subscriber completed:completed];
        };
        
        [object pop_removeAnimationForKey:key];
        [object pop_addAnimation:anim forKey:key];
        
        return [ANYActivity activityWithTearDownBlock:^{
            
            @strongify(object);
            [object pop_removeAnimationForKey:key];
            
        }];
        
    }];
}

@end
