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
    
    CABasicAnimation *alpha0 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"opacity"] duration:3] toValue:@0] build];
    CABasicAnimation *alpha1 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"opacity"] duration:3] toValue:@1] build];
    CABasicAnimation *size0 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"bounds"] duration:5] toValue:[NSValue valueWithCGSize:CGSizeMake(50.0, 50.0)]] build];
    CABasicAnimation *size1 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"bounds"] duration:5] toValue:[NSValue valueWithCGSize:CGSizeMake(50.0, 50.0)]] build];
    CABasicAnimation *pos0 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"position"] duration:5] toValue:[NSValue valueWithCGPoint:CGPointMake(100.0, 300.0)]] build];
    CABasicAnimation *pos1 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"position"] duration:5] toValue:[NSValue valueWithCGPoint:CGPointMake(100.0, 0.0)]] build];
    
    CABasicAnimation *alpha2 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"opacity"] duration:3] toValue:@1] build];
    CABasicAnimation *alpha3 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"opacity"] duration:3] toValue:@0] build];
    CABasicAnimation *size2 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"bounds"] duration:5] toValue:[NSValue valueWithCGSize:CGSizeMake(200.0, 200.0)]] build];
    CABasicAnimation *size3 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"bounds"] duration:5] toValue:[NSValue valueWithCGSize:CGSizeMake(50.0, 50.0)]] build];
    CABasicAnimation *pos2 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"position"] duration:5] toValue:[NSValue valueWithCGPoint:CGPointMake(200.0, 200.0)]] build];
    CABasicAnimation *pos3 = [[[[ANYBasicCoreAnimation animationWithKeyPath:@"position"] duration:5] toValue:[NSValue valueWithCGPoint:CGPointMake(100.0, 100.0)]] build];
    
    ANYAnimation *group0 = [ANYAnimation group:@[
                                               [alpha0 animation:view0.layer],
                                               [size0 animation:view0.layer],
                                               [pos0 animation:view0.layer],
                                               [alpha1 animation:view1.layer],
                                               [size1 animation:view1.layer],
                                               [pos1 animation:view0.layer]
                                               ]];
    
    ANYAnimation *group1 = [ANYAnimation group:@[
                                               [alpha2 animation:view0.layer],
                                               [size2 animation:view0.layer],
                                               [pos2 animation:view0.layer],
                                               [alpha3 animation:view1.layer],
                                               [size3 animation:view1.layer],
                                               [pos3 animation:view0.layer]
                                               ]];
    
    [[[[ANYAnimation group:@[group0]] then:group1] onCompletion:^{
        NSLog(@"ALL ANIMATIONS DONE!");
    }] start];
}
@end
