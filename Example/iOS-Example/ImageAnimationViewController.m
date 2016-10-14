//
// Authors: Mats Hauge <mats@agens.no>
//
// Copyright (c) 2013 Agens AS (http://agens.no/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "ImageAnimationViewController.h"
#import "UndelayedPanRecognizer.h"
#import <Anymotion/Anymotion.h>

@interface ImageAnimationViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) ANYActivity *animation;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGPoint touchPoint;
@property (nonatomic, assign) UITouch *touch;
@property (nonatomic, assign) CGPoint translation;

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
    
    CGRect frame = CGRectMake(300, -500, 250, 172);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = [UIImage imageNamed:@"example-image.jpg"];
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    [[self moveToCenter] start];
    
    UndelayedPanRecognizer *pan = [[UndelayedPanRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}


#pragma mark - Gesture

- (void)handlePanGesture:(UndelayedPanRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        [self.animation cancel];
        
        CGPoint touchPoint = [gesture locationInView:self.imageView];
        [[self scaleDownWithTouchPoint:touchPoint] start];
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        CGPoint center = [gesture locationInView:self.view];
        self.imageView.center = center;
    }
    else if(gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled)
    {
        [[self scaleUp] start];
        
        CGPoint velocity = [gesture velocityInView:self.view];
        self.animation = [[self throwWithVelocity:velocity] start];
    }
}

- (ANYAnimation *)throwWithVelocity:(CGPoint)velocity
{
    NSValue *velocityValue = [NSValue valueWithCGPoint:velocity];
    ANYAnimation *throw = [[[[ANYPOPDecay propertyNamed:kPOPViewCenter] velocity:velocityValue] deceleration:0.992] animationFor:self.imageView];
    
    return [throw then:[ANYAnimation defer:^ANYAnimation * _Nonnull{
        
        [self updateAnchorPointOf:self.imageView to:CGPointMake(0.5, 0.5)];
        
        if (!CGRectIntersectsRect(self.view.bounds, self.imageView.frame))
        {
            return [self moveToCenter];
        }
        
        return [ANYAnimation empty];
    }]];
}

- (ANYAnimation *)moveToCenter
{
    return [ANYAnimation defer:^ANYAnimation *{
        CGPoint center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        return [[[ANYPOPSpring propertyNamed:kPOPViewCenter] toValueWithPoint:center] animationFor:self.imageView];
    }];
}

- (ANYAnimation *)scaleDownWithTouchPoint:(CGPoint)touchPoint
{
    return [ANYAnimation defer:^ANYAnimation *{
        CGPoint anchorPoint = CGPointMake(touchPoint.x / self.imageView.bounds.size.width,
                                          touchPoint.y / self.imageView.bounds.size.height);
        
        [self updateAnchorPointOf:self.imageView to:anchorPoint];
        
        return [[[[[[ANYPOPSpring propertyNamed:kPOPViewScaleXY] toValueWithPoint:CGPointMake(0.95, 0.95)] dynamicsMass:0.1] dynamicsTension:1500] dynamicsFriction:35] animationFor:self.imageView];
    }];
}

- (ANYAnimation *)scaleUp
{
    return [[[[[[ANYPOPSpring propertyNamed:kPOPViewScaleXY] toValueWithPoint:CGPointMake(1, 1)] dynamicsMass:0.1] dynamicsTension:50] dynamicsFriction:2] animationFor:self.imageView];
}

- (void)updateAnchorPointOf:(UIView *)view to:(CGPoint)anchorPoint
{
    CGRect frame = self.imageView.frame;
    self.imageView.layer.anchorPoint = anchorPoint;
    self.imageView.frame = frame;
}


#pragma mark - Gesture Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end

