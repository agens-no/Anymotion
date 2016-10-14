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

#import "ANYCABasic.h"
#import "ANYEXTScope.h"
#import "ANYCALayerAnimationBlockDelegate.h"


@interface ANYCABasic ()
@property (nonatomic, copy) void (^configure)(CABasicAnimation *anim);
@property (nonatomic, assign) BOOL shouldUpdateModel;

@end

@implementation ANYCABasic

+ (instancetype)keyPath:(NSString *)keyPath
{
    return [[self new] configure:^(CABasicAnimation *anim) {
        anim.keyPath = keyPath;
    }];
}

- (instancetype)configure:(void (^)(CABasicAnimation *anim))configure
{
    ANYCABasic *instance = [ANYCABasic new];
    instance.configure = ^(CABasicAnimation *basic){
        if(self.configure)
        {
            self.configure(basic);
        }
        if(configure)
        {
            configure(basic);
        }
    };
    instance.shouldUpdateModel = self.shouldUpdateModel;
    return instance;
}

- (CABasicAnimation *)build
{
    CABasicAnimation *anim = [CABasicAnimation animation];
    self.configure(anim);
    return anim;
}

- (instancetype)toValue:(id)toValue
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.toValue = toValue;
    }];
}

- (instancetype)byValue:(id)byValue
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.byValue = byValue;
    }];
}

- (instancetype)fromValue:(id)fromValue
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.fromValue = fromValue;
    }];
}

- (instancetype)additive:(BOOL)additive
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.additive = additive;
    }];
}

- (instancetype)cumulative:(BOOL)cumulative
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.cumulative = cumulative;
    }];
}

- (instancetype)duration:(NSTimeInterval)duration
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.duration = duration;
    }];
}

- (instancetype)removedOnCompletion:(BOOL)removedOnCompletion
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.removedOnCompletion = removedOnCompletion;
    }];
}

- (instancetype)timingFunction:(CAMediaTimingFunction *)timingFunction
{
    return [self configure:^(CABasicAnimation *anim) {
        anim.timingFunction = timingFunction;
    }];
}

- (ANYAnimation *)animationFor:(CALayer *)layer
{
    @weakify(layer);
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        @strongify(layer);
        
        CABasicAnimation *anim = [self build];
        NSAssert(anim.keyPath.length > 0, @"Missing keypath. Did you construct using +[%@ %@]?", NSStringFromClass([self class]), NSStringFromSelector(@selector(keyPath:)));
        
        __block BOOL failed = NO;
        
        anim.delegate = [ANYCALayerAnimationBlockDelegate newWithAnimationDidStop:^(BOOL completed){
            if(completed)
            {
                [subscriber completed];
            }
            else
            {
                failed = YES;
                [subscriber failed];
            }
        }];
        
        CALayer *presentationLayer = layer.presentationLayer ?: layer;
        anim.fromValue = anim.fromValue ?: [presentationLayer valueForKeyPath:anim.keyPath];
        
        if(self.shouldUpdateModel)
        {
            [self.class applyValue:anim.toValue toLayer:layer animation:anim];
        }
        
        NSString *key = [NSString stringWithFormat:@"any.%@", anim.keyPath];
        [layer removeAnimationForKey:key];
        [layer addAnimation:anim forKey:key];
        
        return [[ANYActivity activityWithTearDownBlock:^{
            
            @strongify(layer);
            if(!failed)
            {
                [layer removeAnimationForKey:key];
                
                if(self.shouldUpdateModel)
                {
                    CALayer *presentationLayer = layer.presentationLayer ?: layer;
                    [self.class applyValue:[presentationLayer valueForKeyPath:anim.keyPath] toLayer:layer animation:anim];
                }
            }
            
        }] nameFormat:@"(CA.basic key: '%@', layer '<%@ %p>')", anim.keyPath, layer.class, layer];
        
    }];
}

+ (void)applyValue:(id)value toLayer:(CALayer *)layer animation:(CABasicAnimation *)animation
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    /*
     If you encounter a crash on this line double check that your `toValue` type is correct for that key path.
     E.g. "transform.scale" for a UIView takes NSNumber – not [NSValue valueWithSize:].
     */
    [layer setValue:value forKeyPath:animation.keyPath];
    
    [CATransaction commit];
}

@end


@implementation ANYCABasic (Convenience)

- (instancetype)updateModel
{
    ANYCABasic *copy = [self configure:nil];
    copy.shouldUpdateModel = YES;
    return copy;
}

@end
