//
//  AfterEffectsPageViewController.m
//  Bombnanza
//
//  Created by Brandon Groff on 4/9/15.
//  Copyright (c) 2015 Brandon Groff. All rights reserved.
//

#import "AfterEffectsPageViewController.h"

@interface AfterEffectsPageViewController ()
@property (strong, nonatomic) NSArray *jsonData;
@property (strong, nonatomic) NSArray *pageIndex;
@end

@implementation AfterEffectsPageViewController
#define DATAPATH @"AfterEffects.json"

-(void)didReceiveMemoryWarning {
    NSLog(@"Memory Warning");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Create the data model
    _jsonData = [self loadJSON];
    _pageIndex = @[@"1", @"2", @"3", @"4"];
    
    // Create page view controller
    self.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = @[startingViewController];
    [self setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageIndex count] == 0) || (index >= [self.pageIndex count])) {
        return NULL;
    }
    // Create a new view controller and pass suitable data.
    PageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    //data
    NSDictionary *data = [[NSDictionary alloc] initWithDictionary:[self.jsonData objectAtIndex:index]];
    pageContentViewController.imageFile = [NSString stringWithFormat:@"PageView%@.png", self.pageIndex[index]];
    pageContentViewController.pageIndex = index;
    pageContentViewController.titleText = [data objectForKey:@"title"];
    pageContentViewController.textFieldText = [data objectForKey:@"content"];
    
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageIndex count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.pageIndex count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

#pragma mark - Data Loading & Parsing

- (NSArray *) loadJSON {
    NSString *filepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATAPATH];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *data = [fileManager contentsAtPath:filepath];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:NULL];
    return [jsonData objectForKey:@"data"];
}

@end
