//
//  ViewController.m
//  Anymotion
//
//  Created by Håvard Fossli on 01.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "ViewController.h"
#import "Anymotion.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *view0 = [[UIView alloc] initWithFrame:CGRectMake(200.0, 200.0, 200.0, 200.0)];
    view0.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view0];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(100.0, 100.0, 50.0, 50.0)];
    view1.backgroundColor = [UIColor blueColor];
    view1.alpha = 0.0;
    [self.view addSubview:view1];
    
    [[[[[ANYBasicPOP new] duration:5] toValue:@0] animationFor:view0 propertyNamed:kPOPViewAlpha] start];
    
    [[[[[[[ANYUIView new] duration:5] delay:1] options:0] block:^{
        view1.alpha = 1.0;
    }] animation] start];
    
    [UIView animateWithDuration:5 delay:1 options:0 animations:^{
        view1.alpha = 1.0;
    } completion:nil];
    
    [ANYUIView animationWithDuration:5 delay:1 options:0 block:^{
        
    }];
}
@end
