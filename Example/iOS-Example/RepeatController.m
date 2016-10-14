//
//  RepeatController.m
//  iOS-Example
//
//  Created by Maria Fossli on 30.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "RepeatController.h"
#import <Anymotion/Anymotion.h>

@implementation RepeatController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"Then + repeat";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];
    
    [self animateView:view];
}

- (void)animateView:(UIView *)view
{
    CGPoint left = CGPointMake(50, view.center.y);
    CGPoint right = CGPointMake(self.view.bounds.size.width - 50, view.center.y);
    
    ANYAnimation *goLeft = [ANYUIView animationWithDuration:0.9 block:^{
        view.center = left;
    }];
    
    ANYAnimation *goRight = [[[ANYPOPSpring propertyNamed:kPOPViewCenter] toValueWithPoint:right] animationFor:view];
    
    [[[goLeft then:goRight] repeat] start];
}

@end
