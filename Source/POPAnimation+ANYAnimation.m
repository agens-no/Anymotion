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

#import "POPAnimation+ANYAnimation.h"
#import "ANYEXTScope.h"

@implementation POPPropertyAnimation (ANYAnimation)

- (ANYAnimation *)animation:(NSObject *)object resetBlock:(void(^)(void))reset
{
    NSString *key = [NSString stringWithFormat:@"ag.%@", self.property.name];
    
    @weakify(object);
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        
        @strongify(object);
        
        reset();
        
        POPAnimation *anim = [object pop_animationForKey:key];
        if (anim == nil || anim != self)
        {
            [object pop_addAnimation:self forKey:key];
        }
        
        void (^oldCompletion)(POPAnimation *, BOOL) = self.completionBlock;
        self.completionBlock = ^(POPAnimation *anim, BOOL success) {
            if(oldCompletion)
            {
                oldCompletion(anim, success);
            }
            if(success)
            {
                [subscriber completed];
            }
            else
            {
                [subscriber failed];
            }
        };
        
        void (^oldApply)(POPAnimation *) = self.animationDidApplyBlock;
        self.animationDidApplyBlock = ^(POPAnimation *anim) {
            if(oldApply)
            {
                oldApply(anim);
            }
            [subscriber write];
        };
        
        return [ANYActivity activityWithBlock:^{
            
            @strongify(object);
            [object pop_removeAnimationForKey:key];
            
        }];
        
    }];
}

- (ANYAnimation *)animation:(NSObject *)object toValue:(id)toValue
{
    @weakify(self);
    return [self animation:object resetBlock:^{
        @strongify(self);
        self.toValue = toValue;
    }];
}

- (ANYAnimation *)animation:(NSObject *)object
{
    return [self animation:object toValue:self.toValue];
}

@end
