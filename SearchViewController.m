//
//  SearchViewController.m
//  Translato
//
//  Created by Jacob Topping on 12-11-19.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import "SearchViewController.h"
#import "AppDelegate.h"
#import "Translation.h"
#import "ViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

@synthesize rowsInTheSQLiteDatabase;
@synthesize SearchTableviewReload;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
        [self.tableView reloadData];
}


- (void)viewDidLoad
{
    //this sets the text color of the top navigation controller menu.
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
    
    //this sets the background image of the top navigation controller menu. Note no file extension is used...
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"top-menu-wood-background"] forBarMetrics: UIBarMetricsDefault];
    
    //this sets the background image of the main viewing area
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhone4S-background.png"]];
    self.view.backgroundColor = [UIColor clearColor];
    
    //setting the bottom bars background. Note, it will propogate throught all bottom bars unless otherwise changed.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom-tab-menu-wood-background.png"]];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
        //iOS 5
        [self.tabBarController.tabBar insertSubview:imageView atIndex:1];
    }
    else {
        //iOS 4.whatever and below
        [self.tabBarController.tabBar insertSubview:imageView atIndex:0];
    }

    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setSearchTableviewReload:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
 // show the cancel button beside the search, only when needed...
- (void)viewWillAppear:(BOOL)animated
{
    UISearchBar *searchBar;
    [searchBar setShowsCancelButton:YES animated:YES];
}
*/

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:YES animated:YES]; // if setShowsCancelButton becomes NO, then the cancel button will magically dissapear!
}

//look for a new clicked on the search bar action method... put it here... put in it: [searchBar setShowsCancelButton:YES animated:YES];
// code goes here when found


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    /*
    // the below code will check if the cancel button is set to NO, if it is, set it to YES... so that the search field will always has it. It's YES by default, but could be no, as per the above code line 76...
     
    if (searchBar setShowsCancelButton: = NO) {
        searchBar setShowsCancelButton = YES;
    }
    */
   
    // Next line, was another attempt to show the cancel button beside the search, only when needed...
    //[searchBar setShowsCancelButton:YES animated:YES];
    
    NSLog(@"%@", searchBar.text);
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSString *searchText = [NSString stringWithFormat:@"*%@*", searchBar.text];
    
    // Test listing all FlashCardDatas from the store
    // eng LIKE '%coke%'
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"eng LIKE[c] %@ OR itali LIKE[c] %@ ", searchText, searchText]; // this is essentially a filter... 
    
    
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
	rowsInTheSQLiteDatabase = [context executeFetchRequest:fetchRequest error:&error];  //this is an array of the objects (aka the rows in the database)... 
    
    [SearchTableviewReload reloadData]; //reloadData will reload the Tableview data again.
    
     NSLog(@"%d", [rowsInTheSQLiteDatabase count]);
    [searchBar resignFirstResponder];
    
}

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
    if([[segue identifier] isEqualToString:@"Final Search Translation"])
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
