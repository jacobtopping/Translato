//
//  TableMenuCategoryTableViewController.m
//  Translato
//
//  Created by Jacob Topping on 12-10-29.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import "TableMenuCategoryTableViewController.h"
#import "SubCatCellsTableViewController.h"
#import "AppDelegate.h"
#import "Translation.h"
#import <QuartzCore/QuartzCore.h>
//#import "LanguageViewController.h"

@interface TableMenuCategoryTableViewController ()

@end

@implementation TableMenuCategoryTableViewController
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
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Translation" 
											  inManagedObjectContext:context];
    NSError *error;
    
    //does the ordering of the info which has been gotton below.
	[fetchRequest setEntity:entity];
	NSSortDescriptor *sortGroup = [[NSSortDescriptor alloc] initWithKey:@"cat" ascending:YES];	
	NSSortDescriptor *sortOrder = [[NSSortDescriptor alloc] initWithKey:@"sub" ascending:YES];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortGroup, sortOrder, nil]];
    
    //does the getting from the database
    NSAttributeDescription* catAttrib = [entity.attributesByName objectForKey:@"cat"];
    NSAttributeDescription* subAttrib = [entity.attributesByName objectForKey:@"sub"];
    NSAttributeDescription* itCatAttrib = [entity.attributesByName objectForKey:@"itCat"];
    NSAttributeDescription* itSubAttrib = [entity.attributesByName objectForKey:@"itSub"];
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:catAttrib, subAttrib, itCatAttrib, itSubAttrib, nil]];
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObjects:catAttrib, subAttrib, itCatAttrib, itSubAttrib, nil]];
    [fetchRequest setResultType:NSDictionaryResultType];

    
	rowsInTheSQLiteDatabase = [context executeFetchRequest:fetchRequest error:&error];  //this is an array of the objects (aka the rows in the database)...  
    
    NSLog(@"%d", [rowsInTheSQLiteDatabase count]);
    
    
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
    
    /* Attempting to change the Nav Title Background, it doesn't like "navBar"...
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImage *image = [UIImage imageNamed:@"topBarBackground.png"];
    [navBar setBackgroundImage:image];
    */
    
    // attempted another way, no errors, but no working either! This uses the Quartz framework
    // self.navigationController.navigationBar.layer.contents = (id)[UIImage imageNamed:@"topBarBackground.png"].CGImage;
    
    // this also compiled, but didn't do anything...
    //[self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"topBarBackground.png"]]];
    
    
    
    //NSLog(@"%d", [rowsInTheSQLiteDatabase objectAtIndex:3]);

    
    //    variable = ;
    //    while (variable!=lastvariable) {
    //        (when next button is clicked ) variable++;
    //    }
    
    
    //NSArray *nextword = 0;
    //Translation *translation = [rowsInTheSQLiteDatabase objectAtIndex:3];
    
    //NSLog(@"Fetched data: cat=%@, sub=%@, eng=%@, itali=%@", translation.cat, translation.sub, translation.eng, translation.itali);
    
    /*
    categoryWord.text=translation.cat;
    subCategoryWord.text=translation.sub;
    EnglishWord.text=translation.eng;
    ItalianWord.text=translation.itali;
    */
    
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
    NSLog(@"%d", [rowsInTheSQLiteDatabase count]);
    return [rowsInTheSQLiteDatabase count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    NSDictionary *data = [rowsInTheSQLiteDatabase objectAtIndex:indexPath.row];
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *language = [prefs stringForKey:@"LanguageSelected"];


    if (language == nil ){
        language = @"eng";
    }
    
    
    
    if ([language isEqualToString:@"eng"]) {  // isEqualToString vs. ==, == is too exacting 
    //build for English case
    cell.textLabel.text = [data objectForKey:@"sub"];
    cell.detailTextLabel.text = [data objectForKey:@"cat"];
    
    } else if ([language isEqualToString:@"ital"]) {
    //Build for Italian case:
    cell.textLabel.text = [data objectForKey:@"itSub"];
    cell.detailTextLabel.text = [data objectForKey:@"itCat"];
    }
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
   cell.textLabel.textColor = [UIColor colorWithRed:156 green:156 blue:156 alpha:1];    
    
    
    //cell.backgroundColor = [UIColor grayColor] ;
    
    
    NSLog(@"Cell %d", indexPath.row );
    NSLog(@"%d", [rowsInTheSQLiteDatabase count]);
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

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
    if([[segue identifier] isEqualToString:@"Go To Categories"])
    {
        SubCatCellsTableViewController *dvc = (SubCatCellsTableViewController *)[segue destinationViewController];
        NSInteger selectedRow = self.tableView.indexPathForSelectedRow.row;
        
        //NSLog(@"%d", selectedRow);
        
        //NSLog(@"%@", [rows objectAtIndex:selectedRow]);
        
        
        
        //NSArray *fields = [[rows objectAtIndex:selectedRow] componentsSeparatedByString:@"|"];
        
        //NSLog(@"%@", [fields objectAtIndex:3]);
        
        
        
        //Translation *translation = [rowsInTheSQLiteDatabase objectAtIndex:selectedRow];
        
        NSDictionary *data = [rowsInTheSQLiteDatabase objectAtIndex:selectedRow];
        dvc.category= [data objectForKey:@"sub"];
    }
    
}


@end
