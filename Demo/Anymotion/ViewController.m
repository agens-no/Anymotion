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
    
    POPBasicAnimation *alpha0 = [[[[ANYBasicPOP propertyNamed:kPOPViewAlpha] duration:3] toValue:@0] build];
    POPBasicAnimation *alpha1 = [[[[ANYBasicPOP propertyNamed:kPOPViewAlpha] duration:3] toValue:@1] build];
    POPBasicAnimation *frame0 = [[[[ANYBasicPOP propertyNamed:kPOPViewFrame] duration:5] toValue:[NSValue valueWithCGRect:CGRectMake(100.0, 300.0, 50.0, 50.0)]] build];
    POPBasicAnimation *frame1 = [[[[ANYBasicPOP propertyNamed:kPOPViewFrame] duration:5] toValue:[NSValue valueWithCGRect:CGRectMake(100.0, 0.0, 50.0, 50.0)]] build];
    
    POPBasicAnimation *alpha2 = [[[[ANYBasicPOP propertyNamed:kPOPViewAlpha] duration:3] toValue:@1] build];
    POPBasicAnimation *alpha3 = [[[[ANYBasicPOP propertyNamed:kPOPViewAlpha] duration:3] toValue:@0] build];
    POPBasicAnimation *frame2 = [[[[ANYBasicPOP propertyNamed:kPOPViewFrame] duration:5] toValue:[NSValue valueWithCGRect:CGRectMake(200.0, 200.0, 200.0, 200.0)]] build];
    POPBasicAnimation *frame3 = [[[[ANYBasicPOP propertyNamed:kPOPViewFrame] duration:5] toValue:[NSValue valueWithCGRect:CGRectMake(100.0, 100.0, 50.0, 50.0)]] build];
    
    ANYAnimation *group0 = [ANYAnimation group:@[
                                               [alpha0 animation:view0],
                                               [frame0 animation:view0],
                                               [alpha1 animation:view1],
                                               [frame1 animation:view1],
                                               ]];
    
    ANYAnimation *group1 = [ANYAnimation group:@[
                                               [alpha2 animation:view0],
                                               [frame2 animation:view0],
                                               [alpha3 animation:view1],
                                               [frame3 animation:view1],
                                               ]];
    
    [[[[ANYAnimation group:@[group0]] then:group1] repeat] start];
}
@end
