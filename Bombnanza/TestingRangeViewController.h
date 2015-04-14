//
//  TestingRangeViewController.h
//  Bombnanza
//
//  Created by Brandon Groff on 4/10/15.
//  Copyright (c) 2015 Brandon Groff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestingRangeViewController : UIViewController
@property (strong, nonatomic) NSDictionary *bombDict;
@property (strong, nonatomic) NSTimer *bombTimer;
@property (nonatomic) CGPoint pos;
@end
