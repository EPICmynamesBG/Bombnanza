//
//  TestingRangeViewController.m
//  Bombnanza
//
//  Created by Brandon Groff on 4/10/15.
//  Copyright (c) 2015 Brandon Groff. All rights reserved.
//

#import "TestingRangeViewController.h"
#import "BombBehavior.h"

@interface TestingRangeViewController () <UIDynamicAnimatorDelegate>
@property (strong, nonatomic) BombBehavior *bombBehavior;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIImageView *fallingBomb;
@end

@implementation TestingRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.bombDict objectForKey:@"name"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self drop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        _animator.delegate = self;
    }
    return _animator;
}

- (BombBehavior *)bombBehavior
{
    if (!_bombBehavior) {
        _bombBehavior = [[BombBehavior alloc] init];
        [self.animator addBehavior:_bombBehavior];
    }
    return _bombBehavior;
}

- (void)drop
{
    CGFloat max;
    if (self.view.bounds.size.height > self.view.bounds.size.width){
        max = self.view.bounds.size.width/3;
    } else {
        max = self.view.bounds.size.height/3;
    }
    
    CGSize dropSize = CGSizeMake(max, max);
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = dropSize;
    int x = (self.view.bounds.size.width-dropSize.width)/2;
    frame.origin.x = x;
    
    UIImageView *dropView = [[UIImageView alloc] initWithFrame:frame];
    dropView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[self.bombDict objectForKey:@"image"]]];
    
    self.fallingBomb = dropView;
    
    [self.view addSubview:self.fallingBomb];
    
    [self.bombBehavior addItem:dropView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
