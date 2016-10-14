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

#import "ButtonViewController.h"

#import <Anymotion/Anymotion.h>

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
    
    UIColor *selectedColor = [UIColor colorWithRed:93.0/255.0 green:215.0/255.0 blue:9.0/255.0 alpha:1.0];
    UIColor *unSelectedColor = [UIColor whiteColor];
    
    UIView *circleView1 = [self createCircleViewWithSize:CGSizeMake(100.0, 100.0) center:self.view.center fillColor:selectedColor];
    [self.view addSubview:circleView1];
    
    UIView *circleView2 = [self createCircleViewWithSize:CGSizeMake(100.0, 100.0) center:self.view.center fillColor:unSelectedColor];
    circleView2.layer.transform = CATransform3DMakeScale(0.001, 0.001, 1.0);
    circleView2.alpha = 0.0;
    [self.view addSubview:circleView2];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 17.0, 7.0)];
    line1.backgroundColor = [UIColor whiteColor];
    line1.layer.anchorPoint = CGPointMake(1.0, 0.5);
    line1.center = CGPointMake(self.view.center.x - 3.5, self.view.center.y + 10.0);
    line1.layer.transform = CATransform3DMakeRotation(DEGREES_TO_RADIANS(45.0), 0, 0, 1);
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 35.0, 7.0)];
    line2.backgroundColor = [UIColor whiteColor];
    line2.layer.anchorPoint = CGPointMake(0.0, 0.5);
    line2.center = CGPointMake(self.view.center.x - 3.5, self.view.center.y + 10.0);
    line2.layer.transform = CATransform3DRotate(line2.layer.transform, DEGREES_TO_RADIANS(-45.0), 0, 0, 1);
    line2.layer.transform = CATransform3DTranslate(line2.layer.transform, -3.5, 0.0, 0.0);
    [self.view addSubview:line2];
    
    ANYAnimation *selectedAnimationGroup = [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        
        ANYAnimation *anim1 = [[[ANYPOPSpring propertyNamed:kPOPLayerScaleXY] toValueWithSize:CGSizeMake(8.0, 8.0)] animationFor:circleView1.layer];
        ANYAnimation *anim2 = [[[ANYPOPSpring propertyNamed:kPOPLayerScaleXY] toValueWithSize:CGSizeMake(2.0, 2.0)] animationFor:circleView2.layer];
        ANYAnimation *anim3 = [[[ANYPOPBasic propertyNamed:kPOPViewBackgroundColor] toValue:selectedColor] animationFor:line1];
        ANYAnimation *anim4 = [[[ANYPOPBasic propertyNamed:kPOPViewBackgroundColor] toValue:selectedColor] animationFor:line2];
        ANYAnimation *anim5 = [[[ANYPOPBasic propertyNamed:kPOPViewAlpha] toValue:@1.0] animationFor:circleView2];
        
        return [[ANYAnimation group:@[anim1, anim2, anim3, anim4, anim5]] start];
        
    }];
    self.selectedAnimationGroup = selectedAnimationGroup;
    
    ANYAnimation *unSelectedAnimationGroup = [ANYAnimation createAnimation:^ANYActivity *(ANYSubscriber *subscriber) {
        
        ANYAnimation *anim1 = [[[ANYPOPSpring propertyNamed:kPOPLayerScaleXY] toValueWithSize:CGSizeMake(1.0, 1.0)] animationFor:circleView1.layer];
        ANYAnimation *anim2 = [[[ANYPOPSpring propertyNamed:kPOPLayerScaleXY] toValueWithSize:CGSizeMake(0.001, 0.001)] animationFor:circleView2.layer];
        ANYAnimation *anim3 = [[[ANYPOPBasic propertyNamed:kPOPViewBackgroundColor] toValue:unSelectedColor] animationFor:line1];
        ANYAnimation *anim4 = [[[ANYPOPBasic propertyNamed:kPOPViewBackgroundColor] toValue:unSelectedColor] animationFor:line2];
        ANYAnimation *anim5 = [[[ANYPOPBasic propertyNamed:kPOPViewAlpha] toValue:@0.0] animationFor:circleView2];
        
        return [[ANYAnimation group:@[anim1, anim2, anim3, anim4, anim5]] start];
        
    }];
    self.unSelectedAnimationGroup = unSelectedAnimationGroup;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.unSelectedAnimationGroup start];
    [super viewWillDisappear:animated];
}



#pragma mark - Create

- (UIView *)createCircleViewWithSize:(CGSize)size center:(CGPoint)center fillColor:(UIColor *)fillColor
{
    CGRect frame = (CGRect){CGPointZero, size};
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.path = [UIBezierPath bezierPathWithOvalInRect:frame].CGPath;
    circleLayer.fillColor = fillColor.CGColor;
    
    UIView *circleView = [[UIView alloc] initWithFrame:frame];
    circleView.center = center;
    [circleView.layer addSublayer:circleLayer];
    
    return circleView;
}



#pragma mark - Gesture

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
