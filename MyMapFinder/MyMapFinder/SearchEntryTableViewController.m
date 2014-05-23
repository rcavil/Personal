//
//  SearchEntryTableViewController.m
//  MyMapFinder
//
//  Created by Ron on 4/26/14.
//  Copyright (c) 2014 Ron Cavil. All rights reserved.
//

#import "SearchEntryTableViewController.h"
#import "SearchEntryStore.h"
#import "EditSearchEntryViewController.h"

@interface SearchEntryTableViewController ()
{
    //Array to hold saved search entries
    NSMutableArray *_searchEntries;
}
@end

@implementation SearchEntryTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //Create left swipe gesture to delete the search entries
    UISwipeGestureRecognizer *gestureLeft;
    gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    gestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
      [[self tableView] addGestureRecognizer:gestureLeft];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self tableView] reloadData];
}

-(void) handleSwipeFrom:(UISwipeGestureRecognizer *) sender
{
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        //functionality to remove current item due to swipe gesture
        CGPoint swipeLocation = [sender locationInView:[self tableView]];
        NSIndexPath *indexPath = [[self tableView] indexPathForRowAtPoint:swipeLocation];
        
        if (indexPath != nil && [indexPath row] < [[SearchEntryStore SharedStore] Count] )
        {
            [[self tableView] beginUpdates];
            [[self tableView] deleteRowsAtIndexPaths:[[NSArray alloc] initWithObjects:indexPath, nil]
                                    withRowAnimation:UITableViewRowAnimationLeft];
            
            [[SearchEntryStore SharedStore] removeEntryAtIndex:[indexPath row]];
            [[self tableView] endUpdates];
        }
                
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[SearchEntryStore SharedStore] Count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    SearchEntry *tempEntry =[[SearchEntryStore SharedStore] EntryAtIndex:[indexPath row]];
    
    //Display the search entry in the table view
    NSString *display = [[NSString alloc] initWithFormat:@"%@", [tempEntry entryName]];
    [[cell textLabel] setText:display];
    
    return cell;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //User double clicked search item, show on map view
    NSInteger row = [indexPath row];
    
    [[SearchEntryStore SharedStore] setCurrentEntry:(row)];
    [self.navigationController popToRootViewControllerAnimated:YES];    
}

/*
 
    if (self.glossaryDetailViewController == nil)
    {
        GlossaryDetailViewController *aGlossaryDetail = [[GlossaryDetailViewController alloc] initWithNibName:@"GlossaryDetailViewController" bundle:nil];
        self.glossaryDetailViewController = aGlossaryDetail;
        [aGlossaryDetail release];
    }
    
    glossaryDetailViewController.glossaryDetailItem = [glossaryArray objectAtIndex:row];
    
    [self.navigationController pushViewController:self.glossaryDetailViewController animated:YES];
 */


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonAddEntry:(UIBarButtonItem *)sender
  {
      //Start the process of adding a new search entry
      
      //temp search entry variable that will be use to create a new search entry
      SearchEntry *tempEntry = [[SearchEntry alloc] init];
      [tempEntry setEntryName:@""];
      
      //Add new search entry via Shared Store
      [[SearchEntryStore SharedStore] addEntry: tempEntry];
      
      //Lauch the detail search entry screen
       
       //Get count of total entries.  Minus 1 due to zero bassed array
       NSInteger entryColumn=[[SearchEntryStore SharedStore] Count]-1;
      
      EditSearchEntryViewController *editSearchEntry = [self.storyboard instantiateViewControllerWithIdentifier:@"editSearchEntry"];
      [editSearchEntry setSearchEntryIndex:entryColumn];
      [self.navigationController pushViewController: editSearchEntry animated: YES];
      
      
  }
@end
