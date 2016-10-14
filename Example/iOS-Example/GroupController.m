//
//  GroupController.m
//  iOS-Example
//
//  Created by Maria Fossli on 30.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "GroupController.h"
#import <Anymotion/Anymotion.h>

@interface GroupController ()

@end

@implementation GroupController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"Group";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *green = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
    green.backgroundColor = [UIColor greenColor];
    [self.view addSubview:green];
    
    UIView *blue = [[UIView alloc] initWithFrame:CGRectMake(20, 220, 100, 100)];
    blue.backgroundColor = [UIColor greenColor];
    [self.view addSubview:blue];
    
    [self animateGreen:green blue:blue];
}

- (void)animateGreen:(UIView *)green blue:(UIView *)blue
{
    CGPoint greenPoint = CGPointMake(self.view.bounds.size.width - 70, green.center.y);
    CGPoint bluePoint = CGPointMake(self.view.bounds.size.width - 70, blue.center.y);
    
    ANYAnimation *greenAnim = [[[[ANYPOPSpring propertyNamed:kPOPViewCenter] toValueWithPoint:greenPoint] springSpeed:0.5] animationFor:green];
    ANYAnimation *blueAnim = [[[[[ANYPOPSpring propertyNamed:kPOPViewCenter] toValueWithPoint:bluePoint] springSpeed:2] dynamicsFriction:100] animationFor:blue];
    
    [[[[[greenAnim onCompletion:^{
        NSLog(@"green completed");
    }] groupWith:[blueAnim onCompletion:^{
        NSLog(@"blue completed");
    }]] onCompletion:^{
        NSLog(@"all completed");
    }] delay:1] start];
    
}

@end
