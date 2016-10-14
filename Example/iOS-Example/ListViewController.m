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
@property (nonatomic, strong) NSArray <UIView *> *views;
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
    
    UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView:)];
    [self.view addGestureRecognizer:tapRecognizer];
    
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    [[[self showList] delay:0.5] start];
}

- (void)didTapView:(UIGestureRecognizer *)gesture
{
    ANYAnimation *hideAndShow = [[self hideList] then:[[self showList] delay:1.0]];
    [hideAndShow start];
}

- (ANYAnimation *)showList
{
    UIView *container = self.containerView;
    
    return [ANYAnimation defer:^ANYAnimation *{
                
        NSArray <UIView *> *views = [self createList];
        for (UIView *view in views)
        {
            [container addSubview:view];
        }
        self.views = views;
        
        ANYAnimation *groupAnimation = [ANYAnimation empty];
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
            
            groupAnimation = [groupAnimation groupWith:animation];
            
            delay += 0.1;
        }
        
        return groupAnimation;
        
    }];
}

- (ANYAnimation *)hideList
{
    NSArray <UIView *> *views = self.views;
    CGRect frame = self.view.bounds;
    frame.origin.y = frame.size.height / 2.0;
    
    UIColor *backgroundColor = views.firstObject.backgroundColor;
    UIView *newContainer = [[UIView alloc] initWithFrame:frame];
    newContainer.backgroundColor = backgroundColor;
    newContainer.layer.transform = CATransform3DMakeScale(1.0, 0.0, 1.0);
    newContainer.layer.anchorPoint = CGPointMake(0.5, 1.0);
    [self.view addSubview:newContainer];
    
    UIView *oldContainer = self.containerView;
    self.containerView = newContainer;
    
    return [[ANYUIView animationWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction block:^{
        newContainer.layer.transform = CATransform3DIdentity;
        oldContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    }] after:^{
        [oldContainer removeFromSuperview];
        newContainer.transform = CGAffineTransformIdentity;
    }];
}

- (NSArray <UIView *> *)createList
{
    NSUInteger numberOfItems = 3;
    CGFloat padding = 100.0;
    CGFloat width = self.containerView.frame.size.width - padding;
    CGFloat height = (self.containerView.frame.size.height - self.navigationController.navigationBar.frame.size.height - padding) / numberOfItems;
    CGRect frame = CGRectMake((padding / 2.0) - (width / 2.0), self.navigationController.navigationBar.frame.size.height + padding / 2.0, width, height);
    
    NSMutableArray <UIView *> *views = [NSMutableArray array];
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

- (UIView *)viewWithFrame:(CGRect)frame color:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

- (NSInteger)randomNumberBetween:(NSInteger)min maxNumber:(NSInteger)max
{
    return min + arc4random() % (max - min);
}

@end
