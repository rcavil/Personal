//
//  SearchEntryStore.m
//  MyMapFinder
//
//  Created by Ron on 4/26/14.
//  Copyright (c) 2014 Ron Cavil. All rights reserved.
//

#import "SearchEntryStore.h"
#import "AppDelegate.h"

@implementation SearchEntryStore

-(id) init
{
    self = [super init];
    if (self)
      {
        _searchEntries = [[NSMutableArray alloc] init];
       [self setCurrentEntry:-1];
          
       if ([self firstTimeAppRun]==true)
       {
         [self addDefaultEntries];
       }
       [self loadCoreData];
       [self sortSearchEntries];
          
      }
    return self;
}

//Declare static reference to add, edit, remove entries
+ (SearchEntryStore *) SharedStore
{
    
    static SearchEntryStore *sharedStore = nil;
    if (!sharedStore)
      {
        sharedStore = [[super allocWithZone:nil] init];
      }
    return sharedStore;
}


- (void) addDefaultEntries
{
    [self clearAllEntries];
    [self saveCoreData:@"gas"];
    [self saveCoreData:@"lodging"];
    [self saveCoreData:@"restaurants"];
}


-(BOOL) firstTimeAppRun
{
    bool firstTime=false;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ( ![userDefaults valueForKey:@"version"] )
    {
        firstTime=true;
        
        // Adding version number to NSUserDefaults for first version:
        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version"];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] floatForKey:@"version"] == [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] )
    {
        /// Same Version
    }
    else
    {
        firstTime=true;
        
        // Update version number to NSUserDefaults for other versions:
        [userDefaults setFloat:[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] floatValue] forKey:@"version"];
    }
    
    return firstTime;
}
- (void) setCurrentEntry:(NSInteger)intCurrentEntry
{
    _currentEntry=intCurrentEntry;
}

- (NSInteger) currentEntry
{
    return (_currentEntry);
}


- (void) incrementCurrentEntry
{
    
    NSInteger numberOfEntries= [self Count];
    NSInteger currentEntryValue= (_currentEntry);
    
    if (currentEntryValue==(numberOfEntries-1))
    {
        [self setCurrentEntry:0];
    }
    else
    {
      [self setCurrentEntry:(currentEntryValue+1)];
    }
    
}

- (void) decrementCurrentEntry
{
    NSInteger numberOfEntries= [self Count];
    NSInteger currentEntryValue= [self currentEntry];
    
    if (currentEntryValue==-1)
    {
        [self setCurrentEntry:0];
    }
    else if (currentEntryValue==0)
    {
        [self setCurrentEntry:(numberOfEntries-1)];
    }
    else
    {
        [self setCurrentEntry:(currentEntryValue-1)];
    }
    
}


- (void) addEntry:(SearchEntry *)searchEntry
{
    [_searchEntries addObject:searchEntry];
}

- (SearchEntry *) EntryAtIndex:(NSInteger) index
{
    return [_searchEntries objectAtIndex:index];
}

- (NSInteger) Count
{
    return [_searchEntries count];
}

- (void) removeEntryAtIndex:(NSInteger) index
{
    SearchEntry *tempEntry=[self EntryAtIndex:(index)];
    
    [_searchEntries removeObjectAtIndex:index];
    [self deleteCoreDataEntry:(tempEntry.entryName)];
}

- (BOOL) searchEntryExists: (NSString*) searchEntry
{
    bool entryExists = false;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"entryName like[c] %@",searchEntry];    
    
    NSArray *results = [_searchEntries filteredArrayUsingPredicate:predicate];
    if ([results count]>0)
    {
        entryExists=true;
    }
    
    return entryExists;
}


-(void) sortSearchEntries
{
    
    NSSortDescriptor* sortByName = [NSSortDescriptor sortDescriptorWithKey:@"entryName" ascending:YES];
    [_searchEntries sortUsingDescriptors:[NSArray arrayWithObject:sortByName]];
    
}

- (void) updateNewEntry:(NSInteger) index :(NSString*) entryName
{

    SearchEntry *tempEntry = [self EntryAtIndex:index];
    [tempEntry setEntryName:entryName];
    
    [self saveCoreData:(entryName)];    
    [self sortSearchEntries];
}


//Core Data methods

-(void) saveCoreData:(NSString*) searchEntry
{
    AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSManagedObject *newSearchEntry;
    
    
    newSearchEntry = [NSEntityDescription
                      insertNewObjectForEntityForName:@"MapSearchEntries"
                      inManagedObjectContext:context];
    
    [newSearchEntry setValue: searchEntry forKey:@"entryName"];
    NSError *error;
    [context save:&error];
    
    if (![context save:&error])
    {
        [self displayAlertView:(@"Data error") :(@"Error saving entry.")];
    }

}

-(void) loadCoreData
{
    NSError *error;
    
    AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"MapSearchEntries" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects)
    {
        [_searchEntries addObject:[SearchEntry AddDefaultEntry:([info valueForKey:@"entryName"])]];
    }
    
}


-(void) deleteCoreDataEntry:(NSString*) searchEntry
{
    
    NSError *error = nil;
    
    AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"MapSearchEntries" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"entryName == %@", searchEntry]];
    
    NSArray* fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects)
    {
        [context deleteObject:info];
        
    }
    
    if (![context save:&error])
    {
        [self displayAlertView:(@"Data error") :(@"Error removing entry.")];
    }
}

- (void) clearAllEntries
{
    AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MapSearchEntries" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    fetchRequest = nil;
    
    for (NSManagedObject *info in fetchedObjects)
    {
        [context deleteObject:info];
        
    }
    
    
    if (![context save:&error])
    {
        [self displayAlertView:(@"Data error") :(@"Error clearing table.")];
    }
    
}

//Display alert view

- (void) displayAlertView:(NSString *)title :(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}


@end
