//
//  FavoritesViewController.m
//  Translato
//
//  Created by Jacob Topping on 12-11-19.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import "FavoritesViewController.h"
#import "AppDelegate.h"
#import "Translation.h"
#import "ViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController
@synthesize rowsInTheSQLiteDatabase;
//@synthesize testFavorites;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//This allows the rows to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES; // this may also be blank... maybe...
}
//
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If you're data source is an NSMutableArray, do this
        Translation *translation = [rowsInTheSQLiteDatabase objectAtIndex:indexPath.row];
        [self UnMakeAFavorite:translation.wordId];
//        [rowsInTheSQLiteDatabase removeObjectAtIndex:indexPath.row];
    }
}

- (void)UnMakeAFavorite:(NSString *)wordId {
    //do something with NS Userdefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *favorites = [[prefs objectForKey:@"favorites"] mutableCopy];
    if (favorites == nil) {
        favorites = [[NSMutableArray alloc] init];
    }
    
    //NSLog(@"This is displaying the translation.wordId %d", [translation.wordId intValue]); //intValue is a method of the NSNumber class...
    
    for (int i = [favorites count] - 1; i >= 0; i--) {
        if ([wordId isEqual:[favorites objectAtIndex:i]]) {
            [favorites removeObjectAtIndex:i];
        }
    }
    
    [prefs setObject:favorites forKey:@"favorites"];
    
    [prefs synchronize]; // forces to save the prefs for next time. Otherwise it only sometimes autosaves... 
    
    NSMutableArray *mutableRowsInDatabase = [rowsInTheSQLiteDatabase mutableCopy];
    for (int i = [mutableRowsInDatabase count] - 1; i >= 0; i--) {
        Translation *translation = [mutableRowsInDatabase objectAtIndex:i];
        if ([wordId isEqual:translation.wordId ]) {
            [mutableRowsInDatabase removeObjectAtIndex:i];
        }
    }
    
    rowsInTheSQLiteDatabase = mutableRowsInDatabase;
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSArray *savedFavorites = [prefs objectForKey:@"favorites"]; // this calls up the actual favorites, from the mutable array created in View Controller.
    
    
    NSLog(@"Here is the # of things in saved favorites: %d", [savedFavorites count]); // this works - check
    
   // NSString *savedNumber = [savedFavorites objectAtIndex:0];
   // NSLog(@"Here is the first item: %@", savedNumber); // currently not working.
   // savedNumber = [savedFavorites objectAtIndex:1];
   // NSLog(@"Here is the second item: %@", savedNumber);
    
    if (savedFavorites != nil) 
    {
        //query on the database
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        // this line is not required... NSString *searchText = [NSString stringWithFormat:@"*%@*", searchBar.text];
        
        // Test listing all FlashCardDatas from the store
        // eng LIKE '%coke%'
   //     NSArray *testFavoritesArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt: 1], [NSNumber numberWithInt: 2], [NSNumber numberWithInt: 3], nil];
        
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"wordId IN %@", savedFavorites];
      //  [fetchRequest setPredicate:predicate];
        
     //   NSPredicate *predicate = [NSPredicate
     //                             predicateWithFormat:@"id IN {1, 2, 3}"]; // this is essentially a filter... 
        
        
        
        // IN is a special sequal command to look through a list of id's...        
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Translation" 
                                                  inManagedObjectContext:context];
        NSError *error;
        
        
        [fetchRequest setEntity:entity];
        NSSortDescriptor *sortGroup = [[NSSortDescriptor alloc] initWithKey:@"cat" ascending:YES];	
        NSSortDescriptor *sortOrder = [[NSSortDescriptor alloc] initWithKey:@"sub" ascending:YES];
        NSSortDescriptor *sortEng = [[NSSortDescriptor alloc] initWithKey:@"eng" ascending:YES];
        
        
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortGroup, sortOrder, sortEng, nil]];
        [fetchRequest setPredicate:predicate];
        rowsInTheSQLiteDatabase = [context executeFetchRequest:fetchRequest error:&error];  
        //tha above array of the objects (aka the rows in the database)...
        
        //need the below line? 
        //[self.tableView reloadData]; //reloadData will reload the Tableview data again.
        
        
        
        
//        self.testFavorites.text = [NSString stringWithFormat:@"You currently have %d favorites.", [savedFavorites count]];
//        self.testFavorites.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8]; 
    }

    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    //this sets the text color of the top navigation controller menu.
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
    
    //this sets the background image of the top navigation controller menu. Note no file extension is used...
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"top-menu-wood-background"] forBarMetrics: UIBarMetricsDefault];
    
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhone4S-background.png"]];
    self.view.backgroundColor = [UIColor clearColor];
    
       
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
//    [self setTestFavorites:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


// This method sets the count to zero, by removing all the objects (but it only works once...!!!!) ???
//, or by subtracting the current count by itself (to give zero)...
/*- (IBAction)resetFavoriteCount:(id)sender {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSMutableArray *savedFavorites = [prefs objectForKey:@"favorites"]; // this calls up the actual favorites, from the mutable array created in View Controller.
    
    if (savedFavorites != nil || savedFavorites == nil) 
    {
        [savedFavorites removeAllObjects];
        // NSMutableArray *savedFavorites = [savedFavorites (count - count)];
        // -[NSMutableArray removeAllObjects];
        // NSMutableArray *savedFavorites = -[NSMutableArray removeAllObjects];
        
        //displays the new count
        self.testFavorites.text = [NSString stringWithFormat:@"You currently have %d favorites.", [savedFavorites count]];
        self.testFavorites.textColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8]; 
    }

}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (rowsInTheSQLiteDatabase == nil)
        return 0;
    else
        return [rowsInTheSQLiteDatabase count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    
    /*
     
     This should be similar to what you see commented-out... 
     NSArray *fields = [[rowsInTheSQLiteDatabase objectAtIndex:indexPath.row] componentsSeparatedByString:@"|"];
     // Above, clearly the 'componentsSeparatedByString:@"|"' must be something else... 
     
     //below is the text's label, and text for the detail lable, as shown on each row.
     cell.textLabel.text = [fields objectAtIndex:0];
     cell.detailTextLabel.text = [fields objectAtIndex:1];
     
     */
    
    
    
    Translation *translation = [rowsInTheSQLiteDatabase objectAtIndex:indexPath.row];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *language = [prefs stringForKey:@"LanguageSelected"];
    
    
    if (language == nil ){
        language = @"eng";
    }
    
    
    
    if ([language isEqualToString:@"eng"]) {  // isEqualToString vs. ==, == is too exacting 
        //build for English case
        cell.textLabel.text = translation.eng;
        cell.detailTextLabel.text = translation.itali;
        //  cell.detailTextLabel.text = [data objectForKey:@"cat"];
        
    } else if ([language isEqualToString:@"ital"]) {
        //Build for Italian case:
        cell.textLabel.text = translation.itali;
        cell.detailTextLabel.text = translation.eng;
        //  cell.detailTextLabel.text = [data objectForKey:@"itCat"];
    }
    
    //cell.textLabel.text = translation.eng;
    //cell.detailTextLabel.text = translation.itali;
    
    cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]; // RGB values are 0.0 to 1.0
    // cell.detailTextLabel.text = translation.sub;
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.8]; // HOW TO CHANGE THE TITLE TEXT COLOR?
    //self.title = translation.sub;
    
    //NSLog(@"Cell %d", indexPath.row );
    //NSLog(@"%d", [rowsInTheSQLiteDatabase count]);
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"From Favorties to Phrase"])
    {
        ViewController *dvc = (ViewController *)[segue destinationViewController];
        NSInteger selectedRow = self.tableView.indexPathForSelectedRow.row;
        
        //NSLog(@"%d", selectedRow);
        
        //NSLog(@"%@", [rows objectAtIndex:selectedRow]);
        
        
        
        //NSArray *fields = [[rows objectAtIndex:selectedRow] componentsSeparatedByString:@"|"];
        
        //NSLog(@"%@", [fields objectAtIndex:3]);
        
        
        
        Translation *translation = [rowsInTheSQLiteDatabase objectAtIndex:selectedRow];
        dvc.wordId= translation.wordId;
    }
    
}

@end
