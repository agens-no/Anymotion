/**
 Copyright (c) 2014-present, Facebook, Inc.
 All rights reserved.
 
 This source code is licensed under the BSD-style license found in the
 LICENSE file in the root directory of this source tree. An additional grant
 of patent rights can be found in the PATENTS file in the same directory.
 */

#import "ANYAnimationDragHelper.h"
#import <UIKit/UIKit.h>
#if TARGET_IPHONE_SIMULATOR && !TEST
#import <dlfcn.h>
#import <mach-o/dyld.h>
#import <objc/runtime.h>
static float (*UIAnimationDragCoefficient)(void) = NULL;
#endif

@interface ANYAnimationDragHelper ()

// private properties and methods

@end

@implementation ANYAnimationDragHelper

+ (void)initialize
{
#if TARGET_IPHONE_SIMULATOR && !TEST
    void *UIKit = dlopen([[[NSBundle bundleForClass:[UIApplication class]] executablePath] fileSystemRepresentation], RTLD_LAZY);
    UIAnimationDragCoefficient = (float (*)(void))dlsym(UIKit, "UIAnimationDragCoefficient");
#endif
}

+ (BOOL)callerIsApplication
{
#if TARGET_IPHONE_SIMULATOR && !TEST
    BOOL callerIsApplication = NO;
    for (uint32_t i = 0; i < _dyld_image_count(); i++)
    {
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header->filetype == MH_EXECUTE)
        {
            Dl_info info;
            if (dladdr(__builtin_return_address(0), &info) != 0)
            {
                callerIsApplication = (info.dli_fbase == header);
                break;
            }
        }
    }
    return callerIsApplication;
#else
    return NO;
#endif
}

+ (double)coefficient
{
#if TARGET_IPHONE_SIMULATOR && !TEST
    return UIAnimationDragCoefficient();
#endif
    return 1.0;
}

@end
