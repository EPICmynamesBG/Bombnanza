//
//  PageContentViewController.h
//  Bombnanza
//
//  Created by Brandon Groff on 4/9/15.
//  Copyright (c) 2015 Brandon Groff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;
@end
