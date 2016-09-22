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
    
    // Repeat
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(200.0, 200.0, 200.0, 200.0)];
    view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:view];
    
    CGPoint left = CGPointMake(50, view.center.y);
    CGPoint right = CGPointMake(self.view.bounds.size.width, view.center.y);
    ANYAnimation *goRight = [[[ANYPOPSpring propertyNamed:kPOPViewAlpha] toValueWithPoint:left] animationFor:view];
    ANYAnimation *goLeft = [[[ANYPOPSpring propertyNamed:kPOPViewAlpha] toValueWithPoint:right] animationFor:view];
    
    __block int count = 0;
    [[[[[goRight then:goLeft] onCompletion:^{
        NSLog(@"Completed cycle %i", count++);
    }] repeat] onCompletionOrError:^(BOOL success) {
        NSLog(@"hmm");
    }] start];
    
}
@end
