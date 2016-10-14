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
