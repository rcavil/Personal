//
//  EditSearchEntryViewController.m
//  MyMapFinder
//
//  Created by Ron on 4/26/14.
//  Copyright (c) 2014 Ron Cavil. All rights reserved.
//

#import "EditSearchEntryViewController.h"
#import "SearchEntry.h"
#import "SearchEntryStore.h"

@interface EditSearchEntryViewController ()

@end

@implementation EditSearchEntryViewController
@synthesize textSearchEntry;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [textSearchEntry becomeFirstResponder];
    
    //Fill the entry text boxes for the entry array value that was passed in
    
    SearchEntry *tempEntry = [[SearchEntryStore SharedStore] EntryAtIndex: _searchEntryIndex];
    [textSearchEntry setText:[tempEntry entryName]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)buttonSearchEntrySave:(UIButton *)sender
{
    //Attempt to save a new search entry
    //Check to see if new entry isn't blank
    //And that new entry doesn't already exist
    
    NSString *origEntryName =[textSearchEntry text];
    NSString *newEntryName = [origEntryName lowercaseString];
    
    if (newEntryName.length==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New search entry is blank"
                                                        message:@"Add cancelled."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [textSearchEntry becomeFirstResponder];
    }
    else
    {
      //See if new entry already exists
      BOOL newEntryExists=[[SearchEntryStore SharedStore] searchEntryExists:(newEntryName)];
    
      if (newEntryExists==false)
      {
          //Save the search entry information from the search entry textboxes
          [[SearchEntryStore SharedStore] updateNewEntry:(_searchEntryIndex) : (newEntryName)];
 
          //dismisses the current view
          [[self navigationController] popViewControllerAnimated:YES];
      }
      else
      {
          NSString *outputString=[NSString stringWithFormat:@"New search entry %@ already exists",newEntryName];

          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:outputString
                                                          message:@"Add cancelled."
                                                         delegate:self
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
          [alert show];
          [textSearchEntry becomeFirstResponder];
      }
    }
 
}

-(void) setSearchEntryIndex:(NSInteger) index
{
    //Set the value of the current search entry
    _searchEntryIndex = index;
    
}


- (IBAction)hideKeyboard:(UITextField *)sender
  {
     [sender resignFirstResponder];
  }

- (IBAction)buttonSearchEntryCancel:(UIButton *)sender
{
    [[SearchEntryStore SharedStore] removeEntryAtIndex:_searchEntryIndex];
    
    //dismisses the current view
    [[self navigationController] popViewControllerAnimated:YES];
}
@end
