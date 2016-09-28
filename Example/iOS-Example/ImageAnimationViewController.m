//
//  ImageAnimationViewController.m
//  Anymotion
//
//  Created by Mats Hauge on 23.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "ImageAnimationViewController.h"

#import <Anymotion/Anymotion.h>

@interface ImageAnimationViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) ANYActivity *animation;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGPoint touchPoint;

@end

@implementation ImageAnimationViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"Image Animation";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect frame = CGRectMake(100.0, 100.0, 250.0, 250.0 / (16.0 / 9.0));
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"image.jpg"];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
}



#pragma mark - Gesture

- (void)handleGesture:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint touchPoint = [gesture locationInView:self.view];
        touchPoint.x = touchPoint.x - self.imageView.frame.origin.x;
        touchPoint.y = touchPoint.y - self.imageView.frame.origin.y;
        self.touchPoint = touchPoint;
        
        CGSize toValue = CGSizeMake(200.0, 200.0 / (16.0 / 9.0));
        [[[[ANYPOPSpring propertyNamed:kPOPLayerSize] toValueWithSize:toValue] animationFor:self.imageView] start];
        
        [self.animation cancel];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint point = [gesture locationInView:self.view];
        point.x = point.x - self.touchPoint.x;
        point.y = point.y - self.touchPoint.y;
        
        CGRect frame = self.imageView.frame;
        frame.origin = point;
        self.imageView.frame = frame;
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
    {
        CGSize toValue1 = CGSizeMake(250.0, 250.0 / (16.0 / 9.0));
        ANYAnimation *anim1 = [[[ANYPOPSpring propertyNamed:kPOPLayerSize] toValueWithSize:toValue1] animationFor:self.imageView];
        
        CGPoint velocity = [gesture velocityInView:self.view];
        NSValue *velocityValue = [NSValue valueWithCGPoint:velocity];
        ANYAnimation *anim2 = [[[ANYPOPDecay propertyNamed:kPOPViewCenter] velocity:velocityValue] animationFor:self.imageView];
        
        self.animation = [[[ANYAnimation group:@[anim1, anim2]] onCompletion:^{
            
            if (!CGRectContainsPoint(self.view.bounds, self.imageView.center))
            {
                [[[[ANYPOPSpring propertyNamed:kPOPViewCenter] toValueWithPoint:self.view.center] animationFor:self.imageView] start];
            }
            
        }] start];
    }
}


#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return CGRectContainsPoint(self.imageView.frame, [touch locationInView:self.view]);
}

@end
