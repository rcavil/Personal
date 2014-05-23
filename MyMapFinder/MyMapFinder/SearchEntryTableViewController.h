//
//  SearchEntryTableViewController.h
//  MyMapFinder
//
//  Created by Ron on 4/26/14.
//  Copyright (c) 2014 Ron Cavil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchEntryTableViewController : UITableViewController
- (IBAction)buttonAddEntry:(UIBarButtonItem *)sender;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
