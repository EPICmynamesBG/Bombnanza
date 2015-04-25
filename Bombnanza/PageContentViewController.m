//
//  PageContentViewController.m
//  Bombnanza
//
//  Created by Brandon Groff on 4/9/15.
//  Copyright (c) 2015 Brandon Groff. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *pageNumberLabel;
@property (weak, nonatomic) IBOutlet UITextView *textFieldTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation PageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
    self.titleLabel.text = self.titleText;
    self.textFieldTextView.text = self.textFieldText;
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long) self.pageIndex+1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
