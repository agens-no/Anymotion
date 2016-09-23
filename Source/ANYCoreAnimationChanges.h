//
//  CoreAnimationChanges.h
//  Anymotion
//
//  Created by Håvard Fossli on 23.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ANYCoreAnimationChanges : NSObject

@property (nonatomic, strong) NSMutableDictionary <NSString *, CAAnimation *> *animationsWithKeys;
@property (nonatomic, strong) NSMutableArray <CAAnimation *> *animationsWithoutKeys;

@end

