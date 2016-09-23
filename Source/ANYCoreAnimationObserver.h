//
//  CoreAnimationObserver.h
//  Anymotion
//
//  Created by Håvard Fossli on 23.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ANYCoreAnimationChanges.h"

@interface ANYCoreAnimationObserver : NSObject

+ (instancetype)shared;

- (NSMapTable <CALayer *, ANYCoreAnimationChanges *> *)addedAnimations:(dispatch_block_t)block;

@end
