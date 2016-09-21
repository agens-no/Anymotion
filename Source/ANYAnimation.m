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

#import "ANYAnimation.h"
#import "ANYSubscriber.h"

@interface ANYAnimation ()

@property (nonatomic, copy) ANYActivity * (^create)(ANYSubscriber *subscriber);

@end

@implementation ANYAnimation

- (instancetype)initWithBlock:(ANYActivity * (^)(ANYSubscriber *subscriber))create
{
    self = [self init];
    if(self)
    {
        self.create = create;
    }
    return self;
}

+ (instancetype)createAnimation:(ANYActivity * (^)(ANYSubscriber *subscriber))create
{
    return [[self alloc] initWithBlock:create];
}

- (ANYActivity *)subscribe:(ANYSubscriber *)subscriber
{
    __typeof__(self.create) create = self.create;

    return ^ANYActivity * (ANYSubscriber *s) {

        ANYActivity *masterActivity = [ANYActivity new];

        ANYSubscriber *intermediate = [[ANYSubscriber alloc] initWithOnWrite:^{
            [s wrote];
        } onCompletion:^{
            [s completed];
            [masterActivity cancel];
        } onError:^{
            [s failed];
            [masterActivity cancel];
        }];

        ANYActivity *activity = create(intermediate);
        [masterActivity add:activity];
        [masterActivity addTearDownBlock:^{
            [s failed];
        }];
        return masterActivity;

    }(subscriber);
}

- (ANYActivity *)subscribeWrite:(dispatch_block_t)next
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnWrite:next onCompletion:nil onError:nil]];
}

- (ANYActivity *)subscribeWrite:(dispatch_block_t)next error:(dispatch_block_t)error
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnWrite:next onCompletion:nil onError:error]];
}

- (ANYActivity *)subscribeWrite:(dispatch_block_t)next completed:(dispatch_block_t)completed
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnWrite:next onCompletion:completed onError:nil]];
}

- (ANYActivity *)subscribeWrite:(dispatch_block_t)next error:(dispatch_block_t)error completed:(dispatch_block_t)completed
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnWrite:next onCompletion:completed onError:error]];
}

- (ANYActivity *)subscribeError:(dispatch_block_t)error
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnWrite:nil onCompletion:nil onError:error]];
}

- (ANYActivity *)subscribeError:(dispatch_block_t)error completed:(dispatch_block_t)completed
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnWrite:nil onCompletion:completed onError:error]];
}

- (ANYActivity *)subscribeCompleted:(dispatch_block_t)completed
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnWrite:nil onCompletion:completed onError:nil]];
}

#pragma mark - Operators

- (ANYActivity *)start
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnWrite:nil onCompletion:nil onError:nil]];
}

- (instancetype)onError:(dispatch_block_t)onError
{
    return [self onError:onError onCompletion:nil];
}

- (instancetype)onCompletion:(dispatch_block_t)onCompletion
{
    return [self onError:nil onCompletion:onCompletion];
}

- (instancetype)onError:(dispatch_block_t)onError onCompletion:(dispatch_block_t)onCompletion
{
    return [self onCompletion:onError onError:onCompletion];
}

- (instancetype)onCompletion:(dispatch_block_t)onCompletion onError:(dispatch_block_t)onError
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        return [self subscribeWrite:^{
            [subscriber wrote];
        } error:^{
            if(onError)
            {
                onError();
            }
            [subscriber failed];
        } completed:^{
            if(onCompletion)
            {
                onCompletion();
            }
            [subscriber completed];
        }];
    }];
}

- (instancetype)onCompletionOrError:(void(^)(BOOL success))onCompletionOrError
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        return [self subscribeWrite:^{
            [subscriber wrote];
        } error:^{
            if(onCompletionOrError)
            {
                onCompletionOrError(NO);
            }
            [subscriber failed];
        } completed:^{
            if(onCompletionOrError)
            {
                onCompletionOrError(YES);
            }
            [subscriber completed];
        }];
    }];
}

- (instancetype)groupWith:(ANYAnimation *)animation
{
    return [ANYAnimation group:@[self, animation]];
}

+ (instancetype)group:(NSArray <ANYAnimation *> *)animations
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {

        ANYActivity *activity = [ANYActivity new];
        
        __block NSUInteger completed = 0;

        for(ANYAnimation *anim in animations)
        {
            ANYActivity *d = [anim subscribeWrite:^{
                [subscriber wrote];
            } error:^{
                [subscriber failed];
            } completed:^{
                completed++;
                if(completed == animations.count)
                {
                    [subscriber completed];
                }
            }]; 
            [activity add:d];
        }

        return activity;
    }];
}

- (instancetype)delay:(NSTimeInterval)delay
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        ANYActivity *master = [ANYActivity new];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            // TODO: Investigate wether we should first check if `master` is cancelled
            // What happens if some activity is cancelled? Should the signal fail?
            ANYActivity *activity = [self subscribe:subscriber];
            [master add:activity];
            
        });
        return master;
    }];
}

- (instancetype)then:(ANYAnimation *)animation
{
    return [ANYAnimation createAnimation:^ANYActivity * (ANYSubscriber *subscriber) {

        ANYActivity *master = [ANYActivity new];

        ANYActivity *first = [self subscribeWrite:^{
            [subscriber wrote];
        } error:^{
            [subscriber failed];
        } completed:^{
            
            // TODO: Investigate wether we should first check if `master` is cancelled
            // What happens if some activity is cancelled? Should the signal fail?
            
            ANYActivity *second = [animation subscribeWrite:^{
                [subscriber wrote];
            } error:^{
                [subscriber failed];
            } completed:^{
                [subscriber completed];
            }];
            
            [master add:second];
        }];

        [master add:first];

        return master;

    }];
}

- (instancetype)repeat
{
    return [ANYAnimation createAnimation:^ANYActivity * (ANYSubscriber *subscriber) {

        __block BOOL cancelled = NO;
        __block ANYActivity *current = nil;

        current = [self subscribeWrite:^{
            [subscriber wrote];
        } error:^{
            [subscriber failed];
        } completed:^{
            if(!cancelled)
            {
                current = [[self repeat] subscribe:subscriber];
            }
        }];

        return [ANYActivity activityWithTearDownBlock:^{
            cancelled = YES;
            [current cancel];
        }];

    }];
}

@end
