//
//  TestingRangeViewController.m
//  Bombnanza
//
//  Created by Brandon Groff on 4/10/15.
//  Copyright (c) 2015 Brandon Groff. All rights reserved.
//

#import "TestingRangeViewController.h"
#import "Math.h"
#include <unistd.h>
#include <netdb.h>

@interface TestingRangeViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) UIImageView *fallingBomb;
@property (strong, nonatomic) UIImageView *explosion;
@property (nonatomic) BOOL timerRepeat;
@property (nonatomic) float fallRate;
@property (nonatomic) float growthFactor;
@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@end

@implementation TestingRangeViewController
#define DATAPATH @"index.html"

#define M_E         2.71828182845904523536028747135266250   /* e */
#define M_LOG2E     1.44269504088896340735992468100189214   /* log 2e */
#define M_LOG10E    0.434294481903251827651128918916605082  /* log 10e */
#define M_LN2       0.693147180559945309417232121458176568  /* log e2 */
#define M_LN10      2.30258509299404568401799145468436421   /* log e10 */
#define M_PI        3.14159265358979323846264338327950288   /* pi */
#define M_PI_2      1.57079632679489661923132169163975144   /* pi/2 */
#define M_PI_4      0.785398163397448309615660845819875721  /* pi/4 */
#define M_1_PI      0.318309886183790671537767526745028724  /* 1/pi */
#define M_2_PI      0.636619772367581343075535053490057448  /* 2/pi */
#define M_2_SQRTPI  1.12837916709551257389615890312154517   /* 2/sqrt(pi) */
#define M_SQRT2     1.41421356237309504880168872420969808   /* sqrt(2) */
#define M_SQRT1_2   0.707106781186547524400844362104849039  /* 1/sqrt(2) */

- (void)viewDidLoad {
    [super viewDidLoad];
    self.WebView.hidden = YES;
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
    if (viewBottom < self.view.frame.size.height+200){
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
    
    CGSize explosionStartSize = CGSizeMake(imageWidth/20, imageHeight/20);
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
    [NSTimer scheduledTimerWithTimeInterval:3.5
                                     target:self
                                   selector:@selector(showMap:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)calculateGrowthFactor {
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
    
    self.growthFactor = powf(M_E-1, log10f(yield))-0.75; //growthRate algorithm
}

- (void)showMap:(NSTimer *) timer { //TODO: create delay to wait until explosion is done, remove explosion, load page
    if ([self isNetworkAvailable]){
        [self.explosion removeFromSuperview];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"]];
        [self.WebView loadRequest:[NSURLRequest requestWithURL:url]];
        self.WebView.hidden = NO;
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Network Connection"
                                                        message:@"Network currently unavailable"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)isNetworkAvailable {
    char *hostname;
    struct hostent *hostinfo;
    hostname = "google.com";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection!\n");
        return NO;
    }
    else{
        NSLog(@"-> connection established!\n");
        return YES;
    }
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
