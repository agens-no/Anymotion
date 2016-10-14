//
//  ScrubbarViewController.m
//  iOS-Example
//
//  Created by Maria Fossli on 01.10.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "ScrubbarViewController.h"

static NSString *identifier = @"foo";

@interface ScrubbarViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation ScrubbarViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.title = @"Scrubbar (Paper like)";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.layout = [UICollectionViewFlowLayout new];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:self.layout];
    self.collectionView.contentInset = UIEdgeInsetsMake(1, 1, 1, 1);
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
    [self.layout invalidateLayout];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = collectionView.bounds.size.height - collectionView.contentInset.top - collectionView.contentInset.bottom;
    CGFloat width = height * (self.view.bounds.size.width / self.view.bounds.size.height);
    return CGSizeMake(width, height);
}

- (NSArray *)colorsForIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row % 5 == 0)
        return @[(id)[UIColor colorWithRed:1.0 green:0.0 blue:0.1 alpha:1.0].CGColor,
                 (id)[UIColor colorWithRed:1.0 green:0.0 blue:1.0 alpha:1.0].CGColor];
    if(indexPath.row % 5 == 1)
        return @[(id)[UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0].CGColor,
                 (id)[UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:1.0].CGColor];
    if(indexPath.row % 5 == 2)
        return @[(id)[UIColor colorWithRed:0.0 green:1.0 blue:0.1 alpha:1.0].CGColor,
                 (id)[UIColor colorWithRed:0.0 green:0.1 blue:1.0 alpha:1.0].CGColor];
    if(indexPath.row % 5 == 3)
        return @[(id)[UIColor colorWithRed:1.0 green:0.1 blue:0.0 alpha:1.0].CGColor,
                 (id)[UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0].CGColor];
    
    return @[(id)[UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0].CGColor,
             (id)[UIColor colorWithRed:0.0 green:1.0 blue:1.0 alpha:1.0].CGColor];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIView *contentView = cell.contentView;
    CAGradientLayer *gradient = (id)contentView.layer.sublayers.firstObject;
    if(gradient == nil)
    {
        gradient = [CAGradientLayer new];
        [contentView.layer addSublayer:gradient];
    }
    gradient.frame = contentView.bounds;
    gradient.colors = [self colorsForIndexPath:indexPath];
    gradient.startPoint = CGPointMake(1.0, 0.0);
    gradient.endPoint = CGPointMake(0.0, 1.0);
    contentView.backgroundColor = [UIColor redColor];
    contentView.layer.cornerRadius = 4.0;
    contentView.clipsToBounds = YES;
    return cell;
}

- (void)pan:(UIPanGestureRecognizer *)recognizer
{
    
}

@end
