/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import <Foundation/Foundation.h>

@interface ANYAnimationDragHelper : NSObject

/// Gives a coefficient which respects slow-animations in simulator
/// Merely a proxy for the private `UIAnimationDragCoefficient()` if target is iphone-simulator
+ (double)coefficient;

@end
