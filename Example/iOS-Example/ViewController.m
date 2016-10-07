//
//  ViewController.m
//  Anymotion
//
//  Created by Håvard Fossli on 01.09.2016.
//  Copyright © 2016 Agens AS. All rights reserved.
//

#import "ViewController.h"
#import "ButtonViewController.h"
#import "ImageAnimationViewController.h"
#import "ListViewController.h"

#import <Anymotion/Anymotion.h>

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *items = @[
                       [ButtonViewController class],
                       [ImageAnimationViewController class],
                       [ListViewController class]
                       ];
    self.items = items;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    UIViewController *viewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    viewController.view.frame = self.view.bounds;
    viewController.title = @"Animations";
    [viewController.view addSubview:tableView];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:navigationController];
    [self.view addSubview:navigationController.view];
    self.navigationController = navigationController;
    
}



#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *viewController = [self viewControllerAtIndexPath:indexPath];
    [self.navigationController pushViewController:viewController animated:YES];
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tableView.cell";
    UIViewController *viewController = [self viewControllerAtIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = viewController.title;
    return cell;
}



#pragma mark - Internals

- (UIViewController *)viewControllerAtIndexPath:(NSIndexPath *)indexPath
{
    Class className = (Class)self.items[indexPath.row];
    UIViewController *viewController = [(UIViewController *)[className alloc] init];
    return viewController;
}

@end
	
