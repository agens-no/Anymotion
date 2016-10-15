//
//  NSObject+ANYSugar.m
//  Anymotion
//
//  Created by Håvard Fossli on 15.10.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "ANYPOPSugar.h"

#define ANY_POP_IMPLEMENTATIONS(property) \
- (instancetype)property##WithInt:(NSInteger)value { return [self property:@(value)]; } \
- (instancetype)property##WithDouble:(CGFloat)value { return [self property:@(value)]; } \
- (instancetype)property##WithPoint:(CGPoint)point { return [self property:[NSValue valueWithCGPoint:point]]; } \
- (instancetype)property##WithSize:(CGSize)size { return [self property:[NSValue valueWithCGSize:size]]; } \
- (instancetype)property##WithRect:(CGRect)rect { return [self property:[NSValue valueWithCGRect:rect]]; } \
- (instancetype)property##WithCGTransform:(CGAffineTransform)transform { return [self property:[NSValue valueWithCGAffineTransform:transform]]; } \
- (instancetype)property##WithCATransform3D:(CATransform3D)transform { return [self property:[NSValue valueWithCATransform3D:transform]]; } \

@implementation ANYPOPSpring (Sugar)

ANY_POP_IMPLEMENTATIONS(velocity)
ANY_POP_IMPLEMENTATIONS(toValue)
ANY_POP_IMPLEMENTATIONS(fromValue)

@end

@implementation ANYPOPBasic (Sugar)

ANY_POP_IMPLEMENTATIONS(toValue)
ANY_POP_IMPLEMENTATIONS(fromValue)

@end

@implementation ANYPOPDecay (Sugar)

ANY_POP_IMPLEMENTATIONS(velocity)
ANY_POP_IMPLEMENTATIONS(fromValue)

@end
