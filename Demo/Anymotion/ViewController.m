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
    
    // then + repeat
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(200.0, 200.0, 200.0, 200.0)];
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];
    
    CGPoint left = CGPointMake(0, view.center.y);
    CGPoint right = CGPointMake(self.view.bounds.size.width, view.center.y);
    ANYAnimation *goLeft = [[[[ANYPOPBasic propertyNamed:kPOPViewCenter] toValueWithPoint:left] duration:3.0] animationFor:view];
    ANYAnimation *goRight = [[[[ANYPOPSpring propertyNamed:kPOPViewCenter] toValueWithPoint:right] springSpeed:1] animationFor:view];
    
    __block int count = 0;
    ANYActivity *activity = [[[[[goRight then:goLeft] onCompletion:^{
        NSLog(@"Completed cycle %i", count++);
    }] repeat] onError:^{
        NSLog(@"Error after cycle %i", count);
    }] start];
    
    
    // Cancel and continue with velocity
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
//        [activity cancel];
//
//        [[[[[[ANYPOPSpring propertyNamed:kPOPViewCenter] toValueWithPoint:CGPointMake(0., 0.)] springSpeed:1] configure:^(POPSpringAnimation *anim) {
//            anim.velocity = [ANYPOPSpring lastActiveAnimationForPropertyNamed:kPOPViewCenter object:view].velocity;
//        }] animationFor:view] start];
//        
//    });
    
}

@end
