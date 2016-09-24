//
//  ViewController.m
//  Anymotion
//
//  Created by Håvard Fossli on 01.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "ViewController.h"
#import <Anymotion/Anymotion.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // then + repeat
    
    ANYAnimation *anim = [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(200.0, 200.0, 200.0, 200.0)];
        view.backgroundColor = [UIColor greenColor];
        [self.view addSubview:view];
        
        CGPoint left = CGPointMake(0, view.center.y);
        CGPoint right = CGPointMake(self.view.bounds.size.width, view.center.y);
        
        ANYAnimation *goLeft = [ANYUIView animationWithDuration:0.5 block:^{
            view.center = left;
        }];
        
        ANYAnimation *goRight = [ANYUIView animationWithDuration:0.5 block:^{
            view.center = right;
        }];
       
        return [[[[goLeft then:goRight] repeat] after:^{
            [view removeFromSuperview];
        }] start];
    }];
    
    [[anim delay:2] start];
    
}

@end
	
