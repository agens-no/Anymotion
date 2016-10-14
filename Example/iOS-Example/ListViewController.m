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

#import "ListViewController.h"

#import <Anymotion/Anymotion.h>

@interface ListViewController ()
@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) UIView *containerView;
@end

@implementation ListViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"List Animation";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    NSArray *views = [self listOfViews];
    for (UIView *view in views)
    {
        [self.containerView addSubview:view];
    }
    self.views = views;
    
    ANYAnimation *animations = [self showListAnimationWithViews:views];
    [[animations delay:1.0] start];
}

- (NSArray *)listOfViews
{
    NSUInteger numberOfItems = 3;
    CGFloat padding = 100.0;
    CGFloat width = self.containerView.frame.size.width - padding;
    CGFloat height = (self.containerView.frame.size.height - self.navigationController.navigationBar.frame.size.height - padding) / numberOfItems;
    CGRect frame = CGRectMake((padding / 2.0) - (width / 2.0), self.navigationController.navigationBar.frame.size.height + padding / 2.0, width, height);
    
    NSMutableArray *views = [NSMutableArray array];
    CATransform3D transform = CATransform3DMakeScale(0.0, 1.0, 1.0);
    CGFloat hue = [self randomNumberBetween:0.0 maxNumber:255.0];
    CGFloat saturation = 255.0;
    
    for (NSUInteger index = 0; index < numberOfItems; index++)
    {
        CGFloat brighness = (((double)index / (double)numberOfItems) * 100.0) + 155;
        UIColor *color = [UIColor colorWithHue:hue/255.0 saturation:saturation/255.0 brightness:brighness/255.0 alpha:1.0];
        
        UIView *view = [self viewWithFrame:frame color:color];
        view.layer.transform = transform;
        [views addObject:view];
        
        frame.origin.y += frame.size.height;
    }
    
    return views;
}

- (ANYAnimation *)showListAnimationWithViews:(NSArray *)views
{
    NSMutableArray *animations = [NSMutableArray array];
    NSTimeInterval delay = 0.0;
    
    for (UIView *view in views)
    {
        NSValue *toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
        CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.19 : 1.0 : 0.22 : 1.0];
     
        ANYAnimation *animation = [[[[[[[[ANYCABasic keyPath:@"transform"] toValue:toValue] timingFunction:timingFunction] updateModel] animationFor:view.layer] before:^{
            view.layer.anchorPoint = CGPointMake(0.0, 0.5);
        }] after:^{
            CGPoint center = view.center;
            center.x = self.containerView.center.x;
            view.layer.anchorPoint = CGPointMake(0.5, 0.5);
            view.center = center;
        }] delay:delay];
        
        [animations addObject:animation];
        
        delay += 0.1;
    }
    
    return [ANYAnimation group:animations];
}

- (UIView *)viewWithFrame:(CGRect)frame color:(UIColor *)color
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view addGestureRecognizer:tapGesture];
    view.backgroundColor = color;
    return view;
}

- (void)didTapView:(UIGestureRecognizer *)gesture
{
    CGRect frame = self.view.bounds;
    frame.origin.y = frame.size.height / 2.0;
    
    UIColor *backgroundColor = gesture.view.backgroundColor;
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = backgroundColor;
    view.layer.transform = CATransform3DMakeScale(1.0, 0.0, 1.0);
    view.layer.anchorPoint = CGPointMake(0.5, 1.0);
    [self.view addSubview:view];
    
    [[[ANYUIView animationWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut block:^{
        view.layer.transform = CATransform3DIdentity;
        self.containerView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }] onCompletion:^{
        
        for (UIView *v in self.views)
        {
            [v removeFromSuperview];
        }
        
        self.containerView.transform = CGAffineTransformIdentity;
        self.containerView.backgroundColor = backgroundColor;
        [view removeFromSuperview];
        
        NSArray *views = [self listOfViews];
        for (UIView *view in views)
        {
            [self.containerView addSubview:view];
        }
        self.views = views;
        
        ANYAnimation *animations = [self showListAnimationWithViews:self.views];
        [[animations delay:2.0] start];
        
    }] start];
}

- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min);
}

@end
