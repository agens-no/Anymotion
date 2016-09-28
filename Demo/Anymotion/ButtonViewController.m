//
//  ButtonViewController.m
//  Anymotion
//
//  Created by Mats Hauge on 23.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "ButtonViewController.h"
#import "ANYUIView.h"

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees) / 180.0)

@interface ButtonViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) ANYAnimation *selectedAnimationGroup;
@property (nonatomic, strong) ANYAnimation *unSelectedAnimationGroup;

@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) BOOL isSelected;

@end

@implementation ButtonViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"Button Animation";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectMake(self.view.center.x - 50.0, self.view.center.y - 10.0, 100.0, 20.0);
    self.frame = frame;
    
    UIView *line1 = [[UIView alloc] initWithFrame:self.frame];
    line1.backgroundColor = [UIColor blueColor];
    line1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45.0));
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:self.frame];
    line2.backgroundColor = [UIColor redColor];
    line2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-45.0));
    [self.view addSubview:line2];
    
    ANYAnimation *selectedAnimationGroup = [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        
        ANYAnimation *rotation = [ANYUIView animationWithDuration:0.5 block:^{
            line1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-60.0));
            line2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(30.0));
        }];
        
        ANYAnimation *frame = [ANYUIView animationWithDuration:0.5 block:^{
            
            CGRect frame1 = line1.frame;
            frame1.size = CGSizeMake(frame1.size.width - 50.0, frame1.size.height);
            line1.frame = frame1;
            
            CGRect frame2 = line2.frame;
            frame2.origin = CGPointMake(self.view.center.x + 11.0, self.view.center.y + 15.0);
            frame2.size = CGSizeMake(frame2.size.width - 56.0, frame2.size.height - 20.0);
            line2.frame = frame2;
            
        }];
        
        return [[ANYAnimation group:@[rotation, frame]] start];
        
    }];
    self.selectedAnimationGroup = selectedAnimationGroup;
    
    ANYAnimation *unSelectedAnimationGroup = [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        
        ANYAnimation *rotation = [ANYUIView animationWithDuration:0.5 block:^{
            line1.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45.0));
            line2.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-45.0));
        }];
        
        ANYAnimation *frame = [ANYUIView animationWithDuration:0.5 block:^{
            line1.frame = self.frame;
            line2.frame = self.frame;
        }];
        
        return [[ANYAnimation group:@[frame]] start];
        
    }];
    self.unSelectedAnimationGroup = unSelectedAnimationGroup;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)handleGesture:(UIGestureRecognizer *)gesture
{
    if (self.isSelected)
    {
        [self.unSelectedAnimationGroup start];
    }
    else
    {
        [self.selectedAnimationGroup start];
    }
    
    self.isSelected =! self.isSelected;
}



#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return CGRectContainsPoint(self.frame, [touch locationInView:self.view]);
}

@end
