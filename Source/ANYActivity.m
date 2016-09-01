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

@interface ANYActivity ()

@property (nonatomic, copy, readwrite) void (^block)(void);
@property (nonatomic, assign, readwrite) BOOL cancelled;

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
 
- (instancetype)initWithBlock:(dispatch_block_t)block
{
    self = [self init];
    if(self)
    {
        _block = block ? [block copy] : [^{} copy];
    }
    return self;
}

+ (instancetype)activityWithBlock:(dispatch_block_t)block
{
    return [[self alloc] initWithBlock:block];
}

- (void)cancel
{
    if(!self.cancelled)
    {
        self.cancelled = YES;
        self.block();
    }
}

- (void)addBlock:(dispatch_block_t)block
{
    if(self.cancelled)
    {
        block();
    }
    else
    {
        void (^current)() = self.block;
        self.block = ^{
            current();
            block();
        };
    }
}

- (void)add:(ANYActivity *)activity
{
    [self addBlock:^{
        [activity cancel];
    }];
}

@end
