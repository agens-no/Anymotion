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

#import "ANYActivity.h"
#import "ANYDefines.h"

@interface ANYActivity ()

@property (nonatomic, copy, readwrite) void (^block)(void);
@property (nonatomic, assign, readwrite) BOOL cancelled;
@property (nonatomic, strong, readonly) NSString *name;

@end

@implementation ANYActivity

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _block = [^{} copy];
    }
    return self;
}
 
- (instancetype)initWithBlock:(dispatch_block_t)block name:(NSString *)name
{
    self = [self init];
    if(self)
    {
        _block = block ? [block copy] : [^{} copy];
        _name = [name copy];
    }
    return self;
}

+ (instancetype)activityWithTearDownBlock:(dispatch_block_t)block
{
    return [[self alloc] initWithBlock:block name:nil];
}

+ (instancetype)activityWithTearDownBlock:(dispatch_block_t)block name:(NSString *)name
{
    return [[self alloc] initWithBlock:block name:name];
}

- (void)cancel
{
    if(!self.cancelled)
    {
        self.cancelled = YES;
        self.block();
    }
}

- (void)add:(ANYActivity *)activity
{
    NSString *name = self.name;
    [self addTearDownBlock:^{
        NSString *debugName USE_ME_TO_DEBUG = name;
        [activity cancel];
    }];
}

- (void)addTearDownBlock:(dispatch_block_t)block
{
    NSString *name = self.name;
    if(self.cancelled)
    {
        NSString *debugName USE_ME_TO_DEBUG = name;
        block();
    }
    else
    {
        void (^current)() = self.block;
        self.block = ^{
            NSString *debugName USE_ME_TO_DEBUG = name;
            current();
            block();
        };
    }
}


@end


@implementation ANYActivity (Debug)

- (NSString *)name
{
    return _name;
}

- (instancetype)name:(NSString *)name
{
    _name = name;
    return self;
}

- (instancetype)nameFormat:(NSString *)format, ...
{
    NSCParameterAssert(format != nil);
    
    va_list args;
    va_start(args, format);
    
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    
    _name = string;
    return self;
}

@end
