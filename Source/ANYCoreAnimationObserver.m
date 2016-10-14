//
//  CoreAnimationObserver.m
//  Anymotion
//
//  Created by Håvard Fossli on 23.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "ANYCoreAnimationObserver.h"
#import "ANYCALayerAnimationBlockDelegate.h"
#import <objc/runtime.h>

@implementation ANYCoreAnimationChange

- (instancetype)initWithLayer:(CALayer *)layer animation:(CAAnimation *)animation key:(NSString *)key
{
    self = [super init];
    if (self)
    {
        _layer = layer;
        _animation = animation;
        _key = key;
    }
    return self;
}

@end

@interface CALayer (Anymotion)
+ (void)_anymotion_swizzleAddAndRemoveAnimation;
@end

@interface ANYCoreAnimtionBlockCallback : NSObject
@property (nonatomic, copy) void (^block)(CALayer *layer, NSString *key, CAAnimation **animation);
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

- (void)addingAnimation:(inout CAAnimation **)animation forKey:(NSString *)key onLayer:(CALayer *)layer
{
    NSDictionary <NSNumber *, ANYCoreAnimtionBlockCallback *> *subscribers = [[self modelForCurrentThread].subscribers copy];
    
    if(subscribers.count > 0)
    {
        for(ANYCoreAnimtionBlockCallback *block in [subscribers objectEnumerator])
        {
            block.block(layer, key, animation);
        }
    }
}

- (CAAnimation *)animationCallbacksByCopyingAnimation:(CAAnimation *)original
                                              onStart:(void(^)(CAAnimation *anim))onStart
                                            onDidStop:(void(^)(CAAnimation *anim, BOOL finished))onStop
{
    CAAnimation *copy = [original copy];
    copy.delegate = [ANYCALayerAnimationBlockDelegate newWithAnimationDidStart:^{
        onStart(copy);
        if([original.delegate respondsToSelector:@selector(animationDidStart:)])
        {
            [original.delegate animationDidStart:original];
        }
    } didStop:^(BOOL finished) {
        onStop(copy, finished);
        if([original.delegate respondsToSelector:@selector(animationDidStop:finished:)])
        {
            [original.delegate animationDidStop:original finished:finished];
        }
    }];
    return copy;
}

- (NSArray <ANYCoreAnimationChange *> *)addedAnimations:(dispatch_block_t)block
                                                onStart:(void(^)(CAAnimation *anim))onStart
                                              onDidStop:(void(^)(CAAnimation *anim, BOOL finished))onStop
{
    CoreAnimationObserverModel *model = [self modelForCurrentThread];
    NSInteger subscriptionId = model.subscriberId++;
    NSNumber *boxed = @(subscriptionId);
    
    NSMutableArray <ANYCoreAnimationChange *> *added = [NSMutableArray new];
    
    ANYCoreAnimtionBlockCallback *callback = [ANYCoreAnimtionBlockCallback new];
    callback.block = ^(CALayer *layer, NSString *key, CAAnimation **animation) {
        
        CAAnimation *original = *animation;
        CAAnimation *copy = [self animationCallbacksByCopyingAnimation:original onStart:onStart onDidStop:onStop];
        
        ANYCoreAnimationChange *change = [[ANYCoreAnimationChange alloc] initWithLayer:layer animation:copy key:key];
        [added addObject:change];
        
        *animation = copy;
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
    CAAnimation *mutated = anim;
    [[ANYCoreAnimationObserver shared] addingAnimation:&mutated forKey:key onLayer:self];
    [self _anymotion_addAnimation:mutated forKey:key];
}

@end
