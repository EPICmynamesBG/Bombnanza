//
//  OneBombViewController.m
//  Bombnanza
//
//  Created by Brandon Groff on 4/10/15.
//  Copyright (c) 2015 Brandon Groff. All rights reserved.
//

#import "OneBombViewController.h"

@interface OneBombViewController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *country;
@property (weak, nonatomic) IBOutlet UILabel *year;
@property (weak, nonatomic) IBOutlet UILabel *blastType;
@property (weak, nonatomic) IBOutlet UILabel *blastRadius;
@property (weak, nonatomic) IBOutlet UILabel *blastYield;
@property (weak, nonatomic) IBOutlet UIImageView *bombImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *descTextField;



@end

@implementation OneBombViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.bombDict){
        self.navigationItem.title = [self.bombDict objectForKey:@"name"];
        self.name.text = [NSString stringWithFormat:@"Name: %@", [self.bombDict objectForKey:@"name"]];
        self.country.text = [NSString stringWithFormat:@"Developing Country: %@", [self.bombDict objectForKey:@"country"]];
        self.year.text = [NSString stringWithFormat:@"Developed in %@", [self.bombDict objectForKey:@"year"]];
        self.blastType.text = [NSString stringWithFormat:@"Type: %@", [self.bombDict objectForKey:@"type"]];
        self.blastRadius.text = [NSString stringWithFormat:@"Blast Radius: %@", [self.bombDict objectForKey:@"blastRadius"]];
        self.blastYield.text = [NSString stringWithFormat:@"Blast Yield: %@", [self.bombDict objectForKey:@"yield"]];
        self.descTextField.text = [self.bombDict objectForKey:@"description"];
        
        self.bombImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [self.bombDict objectForKey:@"image"]]];
        CGFloat width = self.view.bounds.size.width/2.0;
        CGFloat height = (width*self.bombImage.image.size.height)/self.bombImage.image.size.width;
        self.bombImage.frame = CGRectMake(self.bombImage.frame.origin.x, self.bombImage.frame.origin.y, width, height);
        self.bombImage.contentMode = UIViewContentModeScaleAspectFit;
        
        self.descTextField.frame = CGRectMake(self.descTextField.frame.origin.x, self.descTextField.frame.origin.y, width, self.descTextField.frame.size.height);
    }
    else {
        NSLog(@"Empty data set.");
    }
}

@end
