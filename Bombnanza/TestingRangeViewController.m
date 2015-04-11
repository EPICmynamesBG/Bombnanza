//
//  TestingRangeViewController.m
//  Bombnanza
//
//  Created by Brandon Groff on 4/10/15.
//  Copyright (c) 2015 Brandon Groff. All rights reserved.
//

#import "TestingRangeViewController.h"

@interface TestingRangeViewController ()
@property (strong, nonatomic) UIImageView *fallingBomb;
@property (nonatomic) BOOL timerRepeat;
@property (nonatomic) float fallRate;
@end

@implementation TestingRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.bombDict objectForKey:@"name"];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _fallRate = 1.0;
    _timerRepeat = YES;
    [self addBombToView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:(0.03)
                                              target:self
                                            selector:@selector(drop)
                                            userInfo:nil
                                             repeats:self.timerRepeat];
}

- (void)drop
{
    float viewBottom = self.fallingBomb.frame.size.height/2 + self.fallingBomb.center.y;
    if (viewBottom < self.view.frame.size.height){
        self.fallingBomb.center = CGPointMake(self.fallingBomb.center.x + self.pos.x, self.fallingBomb.center.y + self.pos.y);
        _pos = CGPointMake(0.0, self.fallRate);
        _fallRate+= 0.5;
    } else {
        _timerRepeat = NO;
        [self.timer invalidate];
        //explosion!
    }
}

- (void) addBombToView {
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
