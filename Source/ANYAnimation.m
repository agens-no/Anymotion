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
#import "ANYDefines.h"

static NSString *ANYAnimationDefaultName = @"anim";

@interface ANYAnimation () <NSCopying>

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

- (ANYActivity *)start
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnCompletion:nil onError:nil]];
}

- (ANYActivity *)subscribe:(ANYSubscriber *)subscriber
{
    __typeof__(self.create) create = self.create;

    return ^ANYActivity * (ANYSubscriber *s) {
        
        ANYActivity *masterActivity = [ANYActivity new];
        [masterActivity name:ANYAnimationDefaultName];
        
        __block BOOL cancelTriggersError = YES;

        ANYSubscriber *intermediate = [[ANYSubscriber alloc] initWithOnCompletion:^{
            NSString *name USE_ME_TO_DEBUG = masterActivity.name;
            cancelTriggersError = NO;
            [masterActivity cancel];
            [s completed];
        } onError:^{
            NSString *name USE_ME_TO_DEBUG = masterActivity.name;
            cancelTriggersError = NO;
            [masterActivity cancel];
            [s failed];
        }];

        ANYActivity *activity = create(intermediate);
        [masterActivity name:activity.name];
        [masterActivity addTearDownBlock:^{
            NSString *name USE_ME_TO_DEBUG = activity.name;
            [activity cancel];
            if(cancelTriggersError)
            {
                [s failed];
            }
        }];
        
        return masterActivity;

    }(subscriber);
}

- (ANYActivity *)subscribeError:(dispatch_block_t)error
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnCompletion:nil onError:error]];
}

- (ANYActivity *)subscribeError:(dispatch_block_t)error completed:(dispatch_block_t)completed
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnCompletion:completed onError:error]];
}

- (ANYActivity *)subscribeCompleted:(dispatch_block_t)completed
{
    return [self subscribe:[[ANYSubscriber alloc] initWithOnCompletion:completed onError:nil]];
}

@end


@implementation ANYAnimation (Operators)

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
    return [self onCompletion:onCompletion onError:onError];
}

- (instancetype)onCompletion:(dispatch_block_t)onCompletion onError:(dispatch_block_t)onError
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        return [self subscribeError:^{
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
    return [self onCompletion:^{
        if(onCompletionOrError)
        {
            onCompletionOrError(YES);
        }
    } onError:^{
        if(onCompletionOrError)
        {
            onCompletionOrError(NO);
        }
    }];
}

- (instancetype)before:(dispatch_block_t)before
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        if(before)
        {
            before();
        }
        return [self subscribe:subscriber];
    }];
}

- (instancetype)after:(dispatch_block_t)after
{
    return [self onCompletionOrError:^(BOOL success) {
        if(after)
        {
            after();
        }
    }];
}

+ (instancetype)defer:(ANYAnimation *(^)(void))defer
{
    return [ANYAnimation createAnimation:^ANYActivity * (ANYSubscriber *subscriber) {
        
        ANYAnimation *deferred = defer();
        
        return [deferred subscribe:subscriber];
        
    }];
}

- (instancetype)groupWith:(ANYAnimation *)animation
{
    return [ANYAnimation group:@[self, animation]];
}

+ (instancetype)group:(NSArray <ANYAnimation *> *)animations
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        
        __block NSUInteger completed = 0;
        
        ANYActivity *activity = [ANYActivity new];
        NSMutableString *name = [@"(group " mutableCopy];
        
        for(ANYAnimation *anim in animations)
        {
            ANYActivity *d = [anim subscribeError:^{
                [subscriber failed];
            } completed:^{
                completed++;
                if(completed == animations.count)
                {
                    [subscriber completed];
                }
            }]; 
            [activity add:d];
            [name appendString:activity.name];
        }
        
        [name appendString:@")"];
        [activity name:name];
        return activity;
    }];
}

- (instancetype)delay:(NSTimeInterval)delay
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        ANYActivity *master = [ANYActivity new];
        [master nameFormat:@"(delayed ? %.3f seconds)", delay];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if(![master cancelled])
            {
                ANYActivity *activity = [self subscribe:subscriber];
                [master nameFormat:@"(delayed %@ %.3f seconds)", activity.name, delay];
                [master add:activity];
            }
            
        });
        return master;
    }];
}

- (instancetype)then:(ANYAnimation *)animation
{
    return [ANYAnimation createAnimation:^ANYActivity * (ANYSubscriber *subscriber) {

        ANYActivity *master = [ANYActivity new];
        [master name:@"(? then ?)"];

        ANYActivity *first = [self subscribeError:^{
            [subscriber failed];
        } completed:^{
            
            ANYActivity *second = [animation subscribeError:^{
                [subscriber failed];
            } completed:^{
                [subscriber completed];
            }];
            
            [master add:second];
            [master name:[master.name stringByReplacingCharactersInRange:NSMakeRange(master.name.length - 2, 1) withString:second.name]];
        }];

        [master add:first];
        [master nameFormat:@"(%@ then ?)", first.name];

        return master;

    }];
}

- (instancetype)repeat
{
    return [ANYAnimation createAnimation:^ANYActivity * (ANYSubscriber *subscriber) {
        
        ANYActivity *master = [ANYActivity new];
        
        __block BOOL cancelled = NO;
        __block ANYActivity *current = nil;

        current = [self subscribeError:^{
            [master nameFormat:@"(repeat %@)", current.name];
            [subscriber failed];
        } completed:^{
            [master nameFormat:@"(repeat %@)", current.name];
            if(!cancelled)
            {
                current = [[self repeat] subscribe:subscriber];
            }
        }];
        
        [master nameFormat:@"(repeat %@)", current.name];
        [master addTearDownBlock:^{
            cancelled = YES;
            [current cancel];
        }];
        return master;

    }];
}

@end


@implementation ANYAnimation (Debug)

- (instancetype)name:(NSString *)name
{
    return [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        ANYActivity *activity = [self subscribe:subscriber];
        return [[ANYActivity activityWithTearDownBlock:^{
            [activity cancel];
        }] name:activity.name];
    }];
}

- (instancetype)nameFormat:(NSString *)format, ...
{
    NSCParameterAssert(format != nil);
    
    va_list args;
    va_start(args, format);
    
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    return [self name:string];
}

@end
