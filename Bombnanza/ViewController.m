//
//  ViewController.m
//  Bombnanza
//
//  Created by Brandon Groff on 4/3/15.
//  Copyright (c) 2015 Brandon Groff. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIButton *view1Button;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

@end
