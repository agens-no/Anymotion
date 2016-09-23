//
//  CoreAnimationObserver.m
//  Anymotion
//
//  Created by Håvard Fossli on 23.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "ANYCoreAnimationObserver.h"
#import <objc/runtime.h>

@interface CALayer (Anymotion)
+ (void)_anymotion_swizzleAddAndRemoveAnimation;
@end

@interface ANYCoreAnimtionBlockCallback : NSObject
@property (nonatomic, copy) void (^block)(CALayer *layer, NSString *key, CAAnimation *animation);
@end
@implementation ANYCoreAnimtionBlockCallback
@end

@interface CoreAnimationObserverModel : NSObject
@property (nonatomic, assign) NSInteger subscriberId;
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, ANYCoreAnimtionBlockCallback *> *subscribers;
@end
@implementation CoreAnimationObserverModel
@end

@implementation ANYCoreAnimationObserver

+ (instancetype)shared
{
    static ANYCoreAnimationObserver *observer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        observer = [[self alloc] initHidden];
    });
    return observer;
}

- (instancetype)init
{
    return nil;
}

- (instancetype)initHidden
{
    self = [super init];
    if (self)
    {
        [CALayer _anymotion_swizzleAddAndRemoveAnimation];
    }
    return self;
}

- (CoreAnimationObserverModel *)modelForCurrentThread
{
    static NSString *key = @"AnymotionCoreAnimationObserverModel";
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    CoreAnimationObserverModel *model = threadDict[key];
    if(model == nil)
    {
        model = [CoreAnimationObserverModel new];
        model.subscribers = [NSMutableDictionary new];
        threadDict[key] = model;
    }
    return model;
}

- (void)addedAnimation:(CAAnimation *)animation forKey:(NSString *)key onLayer:(CALayer *)layer
{
    CoreAnimationObserverModel *model = [self modelForCurrentThread];
    for(ANYCoreAnimtionBlockCallback *block in [model.subscribers objectEnumerator])
    {
        block.block(layer, key, animation);
    }
}

- (NSMapTable <CALayer *, ANYCoreAnimationChanges *> *)addedAnimations:(dispatch_block_t)block
{
    CoreAnimationObserverModel *model = [self modelForCurrentThread];
    NSInteger subscriptionId = model.subscriberId++;
    NSNumber *boxed = @(subscriptionId);
    
    NSMapTable <CALayer *, ANYCoreAnimationChanges *> *added = [NSMapTable weakToStrongObjectsMapTable];
    
    ANYCoreAnimtionBlockCallback *callback = [ANYCoreAnimtionBlockCallback new];
    callback.block = ^(CALayer *layer, NSString *key, CAAnimation *animation) {
        
        ANYCoreAnimationChanges *changesForLayer = [added objectForKey:layer];
        if(changesForLayer == nil)
        {
            changesForLayer = [ANYCoreAnimationChanges new];
            changesForLayer.animationsWithKeys = [NSMutableDictionary new];
            changesForLayer.animationsWithoutKeys = [NSMutableArray new];
            [added setObject:changesForLayer forKey:layer];
        }
        
        if(key)
        {
            changesForLayer.animationsWithKeys[key] = animation;
        }
        else
        {
            [changesForLayer.animationsWithoutKeys addObject:animation];
        }
    };
    
    model.subscribers[boxed] = callback;
    block();
    model.subscribers[boxed] = nil;
    return added;
}

@end

@implementation CALayer (Anymotion)

static void AnymotionSwizzleMethods(Class c, SEL orig, SEL new)
{
    struct objc_method *origMethod = class_getInstanceMethod(c, orig);
    struct objc_method *newMethod = class_getInstanceMethod(c, new);
    if(class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod)))
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    else
        method_exchangeImplementations(origMethod, newMethod);
}

+ (void)_anymotion_swizzleAddAndRemoveAnimation
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        AnymotionSwizzleMethods([CALayer class], @selector(addAnimation:forKey:), @selector(_anymotion_addAnimation:forKey:));
    });
}

- (void)_anymotion_addAnimation:(CAAnimation *)anim forKey:(nullable NSString *)key
{
    [[ANYCoreAnimationObserver shared] addedAnimation:anim forKey:key onLayer:self];
    [self _anymotion_addAnimation:anim forKey:key];
}

@end
