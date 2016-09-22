//
//  ANYPOPMemoryTable.h
//  Anymotion
//
//  Created by Håvard Fossli on 22.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pop/pop.h>

@interface ANYPOPMemoryTable <__covariant POPAnimation> : NSObject

- (POPAnimation)animationForProperty:(POPAnimatableProperty *)property object:(NSObject *)object;
- (void)setAnimation:(POPAnimation)animation forProperty:(POPAnimatableProperty *)property object:(NSObject *)object;

@end
