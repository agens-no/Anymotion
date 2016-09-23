//
//  CoreAnimationChanges.m
//  Anymotion
//
//  Created by Håvard Fossli on 23.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "ANYCoreAnimationChanges.h"

@implementation ANYCoreAnimationChanges

- (NSString *)description
{
    NSMutableString *description = [NSMutableString string];
    [description appendFormat:@"%@ {", [super description]];
    
    [description appendFormat:@"\n\r\tanimationsWithKeys: %@", _animationsWithKeys];
    [description appendFormat:@"\n\r\tanimationsWithoutKeys: %@", _animationsWithoutKeys];
    
    [description appendString:@"\n\r}"];
    
    return description;
}

@end
