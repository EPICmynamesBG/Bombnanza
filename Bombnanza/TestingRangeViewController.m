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
@property (strong, nonatomic) UIImageView *explosion;
@property (nonatomic) BOOL timerRepeat;
@property (nonatomic) float fallRate;
@property (nonatomic) float growthFactor;
@end

@implementation TestingRangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [self.bombDict objectForKey:@"name"];
    [self addBombToView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self calculateGrowthFactor];
    _fallRate = 1.0;
    _timerRepeat = YES;
    
    _bombTimer = [NSTimer scheduledTimerWithTimeInterval:(0.03)
                                                  target:self
                                                selector:@selector(drop)
                                                userInfo:nil
                                                 repeats:self.timerRepeat];
}

#pragma mark - Bomb Drop

- (void)drop
{
    float viewBottom = self.fallingBomb.frame.size.height/2 + self.fallingBomb.center.y;
    if (viewBottom < self.view.frame.size.height){
        self.fallingBomb.center = CGPointMake(self.fallingBomb.center.x + self.pos.x, self.fallingBomb.center.y + self.pos.y);
        _pos = CGPointMake(0.0, self.fallRate);
        _fallRate+= 0.7;
    } else {
        _timerRepeat = NO;
        [self.bombTimer invalidate];
        [self removeBombFromView];
        [self explosionEffect];
        //explosion!
    }
}

- (void) addBombToView {
    
    CGFloat imageWidthRelativeToDisplay, imageHeight, imageWidth;
    UIImage *bomb = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[self.bombDict objectForKey:@"image"]]];
    //image size calculations
    if (self.view.bounds.size.height > self.view.bounds.size.width){
        imageWidthRelativeToDisplay = self.view.bounds.size.width/3;
    } else {
        imageWidthRelativeToDisplay = self.view.bounds.size.height/3;
    }
    imageHeight = ((bomb.size.height*imageWidthRelativeToDisplay)/bomb.size.width);
    imageWidth = imageWidthRelativeToDisplay;
    
    if (imageHeight > self.view.bounds.size.height/5){
        imageHeight = self.view.bounds.size.height/5;
        imageWidth = ((imageHeight*bomb.size.width)/bomb.size.height);
    }
    
    CGSize dropSize = CGSizeMake(imageWidth, imageHeight);
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = dropSize;
    int x = (self.view.bounds.size.width-dropSize.width)/2;
    frame.origin.x = x;
    
    UIImageView *dropView = [[UIImageView alloc] initWithFrame:frame];
    dropView.image = bomb;
    
    self.fallingBomb = dropView;
    
    [self.view addSubview:self.fallingBomb];
}

- (void) removeBombFromView {
    [self.fallingBomb removeFromSuperview];
}

#pragma mark - Explosion Effect

-(void) explosionEffect {
    CGFloat imageWidthRelativeToDisplay, imageHeight, imageWidth;
    UIImage *explode = [UIImage imageNamed:@"mushroomcloud.png"];
    //image size calculations
    if (self.view.bounds.size.height > self.view.bounds.size.width){
        imageWidthRelativeToDisplay = self.view.bounds.size.width/3;
    } else {
        imageWidthRelativeToDisplay = self.view.bounds.size.height/3;
    }
    imageHeight = ((explode.size.height*imageWidthRelativeToDisplay)/explode.size.width);
    imageWidth = imageWidthRelativeToDisplay;
    
    if (imageHeight > self.view.bounds.size.height/5){
        imageHeight = self.view.bounds.size.height/5;
        imageWidth = ((imageHeight*explode.size.width)/explode.size.height);
    }
    
    CGSize explosionStartSize = CGSizeMake(imageWidth, imageHeight);
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = explosionStartSize;
    int x = ((self.view.bounds.size.width-explosionStartSize.width)/2);
    int y = (self.view.bounds.size.height-explosionStartSize.height)+(self.view.bounds.size.height/27);
    int x2 = ((self.view.bounds.size.width-(imageWidth*self.growthFactor))/2);
    int y2 = (self.view.bounds.size.height-(imageHeight*self.growthFactor))+(self.view.bounds.size.height/27);
    frame.origin.x = x;
    frame.origin.y = y;
    
    UIImageView *boom = [[UIImageView alloc] initWithFrame:frame];
    boom.image = explode;
    
    self.explosion = boom;
    [self.view addSubview:self.explosion];
    
    //animation
    [self.explosion startAnimating];
    [UIView animateWithDuration:2.0 animations:^{
        self.explosion.frame = CGRectMake(x2, y2, imageWidth*self.growthFactor, imageHeight*self.growthFactor);
    }];
    [self.explosion stopAnimating];
}

- (void)calculateGrowthFactor {
    float baseGrowth = 1.1;
    NSMutableString *yieldString = [[NSMutableString alloc] initWithString:[self.bombDict objectForKey:@"yield"]];
    NSUInteger index = 0;
    @try {
        index = [yieldString rangeOfString:@"-"].location;
        if (index > yieldString.length){
            index = 0;
        }
        if (index == 0){
            index = [yieldString rangeOfString:@" "].location;
        }
        if (index > yieldString.length){
            index = 0;
        }
        if (index == 0){
            index = yieldString.length-1;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception thrown");
    }
    @finally {
        //NSLog(@"Finally");
    }
    
    
    NSString *yieldSubstring = [[NSString alloc] initWithString:[yieldString substringToIndex:index]];
    float yield = [yieldSubstring floatValue];
    
    self.growthFactor = yield/10*baseGrowth;
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
