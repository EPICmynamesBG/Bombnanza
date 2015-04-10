//
//  KnowledgeTableViewController.m
//  Bombnanza
//
//  Created by Brandon Groff on 4/3/15.
//  Copyright (c) 2015 Brandon Groff. All rights reserved.
//

#import "KnowledgeTableViewController.h"
#import "OneBombViewController.h"

@interface KnowledgeTableViewController ()
@property (strong, nonatomic) NSArray *jsonData;
@end

@implementation KnowledgeTableViewController
#define DATAPATH @"Bombs.json"
- (void)viewDidLoad {
    [super viewDidLoad];
    _jsonData = [[NSArray alloc] initWithArray:[self loadJSON]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.jsonData count];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KnowledgeCell" forIndexPath:indexPath];
    NSString *title = [[self.jsonData objectAtIndex:indexPath.row] objectForKey:@"name"];
    NSString *country = [[self.jsonData objectAtIndex:indexPath.row] objectForKey:@"country"];
    cell.tag = indexPath.row;
    cell.textLabel.text = title;
    cell.detailTextLabel.text = country;
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"knowBomb"]){
        OneBombViewController *destination = segue.destinationViewController;
        destination.bombDict = [self.jsonData objectAtIndex:[sender tag]];
    }
}


@end
