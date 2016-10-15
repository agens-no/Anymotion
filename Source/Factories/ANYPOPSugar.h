//
//  NSObject+ANYSugar.h
//  Anymotion
//
//  Created by Håvard Fossli on 15.10.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANYPOPSpring.h"
#import "ANYPOPBasic.h"
#import "ANYPOPDecay.h"

#define ANY_POP_DECLARATIONS(name) \
- (instancetype)name##WithInt:(NSInteger)value NS_SWIFT_NAME(name(_:)); \
- (instancetype)name##WithDouble:(CGFloat)value NS_SWIFT_NAME(name(_:)); \
- (instancetype)name##WithPoint:(CGPoint)point NS_SWIFT_NAME(name(_:)); \
- (instancetype)name##WithSize:(CGSize)size NS_SWIFT_NAME(name(_:)); \
- (instancetype)name##WithRect:(CGRect)rect NS_SWIFT_NAME(name(_:)); \
- (instancetype)name##WithCGTransform:(CGAffineTransform)transform NS_SWIFT_NAME(name(_:)); \
- (instancetype)name##WithCATransform3D:(CATransform3D)transform NS_SWIFT_NAME(name(_:)); \

@interface ANYPOPSpring (POPSugar)

ANY_POP_DECLARATIONS(velocity)
ANY_POP_DECLARATIONS(toValue)
ANY_POP_DECLARATIONS(fromValue)

@end

@interface ANYPOPBasic (POPSugar)

ANY_POP_DECLARATIONS(toValue)
ANY_POP_DECLARATIONS(fromValue)

@end

@interface ANYPOPDecay (POPSugar)

ANY_POP_DECLARATIONS(velocity)
ANY_POP_DECLARATIONS(fromValue)

@end
