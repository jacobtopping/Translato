//
//  SubCatCellsTableViewController.m
//  Translato
//
//  Created by Jacob Topping on 12-11-14.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import "SubCatCellsTableViewController.h"
#import "AppDelegate.h"
#import "Translation.h"
#import "ViewController.h"

@interface SubCatCellsTableViewController ()

@end

@implementation SubCatCellsTableViewController

//@synthesize rows;
@synthesize category;
@synthesize rowsInTheSQLiteDatabase;



- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData]; 
    
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) didTapBackButton:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Test listing all FlashCardDatas from the store
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"sub = %@", category]; // this is essentially a filter... 
    
    
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
    
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhone4S-background.png"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    //change back button image
    if(self.navigationController.viewControllers.count > 1) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(didTapBackButton:) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(0.0f, 0.0f, 64.0f, 41.0f);
        backButton.titleLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:57.0/255.0 blue:19.0/255.0 alpha:1.0]; // creeated this line myself... ohh ahhh!
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [rowsInTheSQLiteDatabase count];
    

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"pickedCell";
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
        //  cell.detailTextLabel.text = [data objectForKey:@"cat"];
        
    } else if ([language isEqualToString:@"ital"]) {
        //Build for Italian case:
        cell.textLabel.text = translation.itali;
      //  cell.detailTextLabel.text = [data objectForKey:@"itCat"];
    }

    
    
    cell.textLabel.textColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1]; // RGB values are 0.0 to 1.0
   // cell.detailTextLabel.text = translation.sub;
    
   // self.title.textColor = [UIColor colorWithRed:46 green:57 blue:19 alpha:0.8]; // HOW TO CHANGE THE TITLE TEXT COLOR?
    self.title = translation.sub;
    
    NSLog(@"Cell %d", indexPath.row );
    NSLog(@"%d", [rowsInTheSQLiteDatabase count]);
    
    return cell;
}



//#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"Final Translation"])
    {
        ViewController *dvc = (ViewController *)[segue destinationViewController];
        NSInteger selectedRow = self.tableView.indexPathForSelectedRow.row;
        
        //NSLog(@"%d", selectedRow);
        
        //NSLog(@"%@", [rows objectAtIndex:selectedRow]);
        
        
        
        //NSArray *fields = [[rows objectAtIndex:selectedRow] componentsSeparatedByString:@"|"];
        
        //NSLog(@"%@", [fields objectAtIndex:3]);
        
        
        
        Translation *translation = [rowsInTheSQLiteDatabase objectAtIndex:selectedRow];
        dvc.wordId= translation.wordId;
        //dvc.english= translation.eng;
    }
    
}


@end
