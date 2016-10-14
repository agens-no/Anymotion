//
//  CoreAnimationObserver.h
//  Anymotion
//
//  Created by Håvard Fossli on 23.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface ANYCoreAnimationChange : NSObject

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, weak, readonly) __kindof CALayer *layer;
@property (nonatomic, strong, readonly) __kindof CAAnimation *animation;

@property (nonatomic, copy) void (^onStart)(CAAnimation *anim);
@property (nonatomic, copy) void (^onStop)(CAAnimation *anim, BOOL finished);
@property (nonatomic, copy) void (^onRemove)(CAAnimation *anim);

@end

@interface ANYCoreAnimationObserver : NSObject

+ (instancetype)shared;

- (NSArray <ANYCoreAnimationChange *> *)addedAnimations:(dispatch_block_t)block
                                                onStart:(void(^)(CAAnimation *anim))onStart
                                              onDidStop:(void(^)(CAAnimation *anim, BOOL finished))onStop;

@end
