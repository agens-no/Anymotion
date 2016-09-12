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
    
    ANYAnimation *anim = [[[[ANYBasicPOP new] duration:5] toValue:@0] animationFor:view0 propertyNamed:kPOPViewAlpha];
    
    [[ANYSpringPOP new] configure:^(POPSpringAnimation *anim) {
        anim.velocity = @"asdlfkjasldk";
    }];
    [anim start];
}
@end
