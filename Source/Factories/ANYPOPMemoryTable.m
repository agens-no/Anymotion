//
//  ANYPOPMemoryTable.m
//  Anymotion
//
//  Created by Håvard Fossli on 22.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

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
