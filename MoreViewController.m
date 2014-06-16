//
//  MoreViewController.m
//  Translato
//
//  Created by Jacob Topping on 12-11-19.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
