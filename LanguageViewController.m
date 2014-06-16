//
//  LanguageViewController.m
//  Translato
//
//  Created by Jacob Topping on 12-11-19.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import "LanguageViewController.h"

@interface LanguageViewController ()

@end

@implementation LanguageViewController
@synthesize LanguageSelector;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //to preset the correct selector

    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *language = [prefs objectForKey:@"LanguageSelected"];
    
    if ([language isEqual:@"eng"]) {
        LanguageSelector.selectedSegmentIndex = 0;
    } else if ([language isEqual:@"ital"]) {
        LanguageSelector.selectedSegmentIndex = 1; // add this sort of else if statement, for each language.
    }
    
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
    [self setLanguageSelector:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)EnglishToItalian:(id)sender {
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (LanguageSelector.selectedSegmentIndex == 0){    //0=english
        [prefs setObject:@"eng" forKey:@"LanguageSelected"];
    }
    else if (LanguageSelector.selectedSegmentIndex == 1) {     //1=Italian
        [prefs setObject:@"ital" forKey:@"LanguageSelected"];
    }
    [prefs synchronize]; // forces to save the prefs for next time. Otherwise it only sometimes autosaves... 
}
@end
