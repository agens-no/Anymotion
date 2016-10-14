//
// Authors: Mats Hauge <mats@agens.no>
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

#import "ANYPOPMemoryTable.h"

@interface ANYPOPMemoryTable ()

@property (nonatomic, strong) NSMapTable <POPAnimatableProperty *, NSMapTable <NSObject *, POPAnimation *> *> *table;

@end

@implementation ANYPOPMemoryTable

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _table = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

- (NSMapTable <NSObject *, POPAnimation *> *)tableForProperty:(POPAnimatableProperty *)property
{
    NSMapTable <NSObject *, POPAnimation *> *table = [self.table objectForKey:property];
    if(table == nil)
    {
        table = [NSMapTable weakToStrongObjectsMapTable];
        [self.table setObject:table forKey:property];
    }
    return table;
}

- (POPAnimation *)animationForProperty:(POPAnimatableProperty *)property object:(NSObject *)object
{
    NSMapTable <NSObject *, POPAnimation *> *table = [self tableForProperty:property];
    return [table objectForKey:object];
}

- (void)setAnimation:(POPAnimation *)animation forProperty:(POPAnimatableProperty *)property object:(NSObject *)object
{
    NSMapTable <NSObject *, POPAnimation *> *table = [self tableForProperty:property];
    [table setObject:animation forKey:object];
}

@end
