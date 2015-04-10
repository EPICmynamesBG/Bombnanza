//
//  BombRangeTableViewController.m
//  Bombnanza
//
//  Created by Brandon Groff on 4/3/15.
//  Copyright (c) 2015 Brandon Groff. All rights reserved.
//

#import "BombRangeTableViewController.h"
#import "TestingRangeViewController.h"

@interface BombRangeTableViewController ()
@property (strong, nonatomic) NSArray *jsonData;
@end

@implementation BombRangeTableViewController
#define DATAPATH @"Bombs.json"

- (void)viewDidLoad {
    [super viewDidLoad];
    _jsonData = [[NSArray alloc] initWithArray:[self loadJSON]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray *) loadJSON {
    NSString *filepath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:DATAPATH];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *data = [fileManager contentsAtPath:filepath];
    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:NULL];
    return [jsonData objectForKey:@"data"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.jsonData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BombCell" forIndexPath:indexPath];
    NSString *title = [[self.jsonData objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.tag = indexPath.row;
    cell.textLabel.text = title;
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"testingRange"]){
        TestingRangeViewController *destination = segue.destinationViewController;
        NSDictionary *temp = [[NSDictionary alloc] initWithDictionary:[self.jsonData objectAtIndex:[sender tag]]];
        NSLog(@"%@", temp);
        destination.bombDict = temp;
    }
}


@end
