//
//  FavoritesViewController.h
//  Translato
//
//  Created by Jacob Topping on 12-11-19.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesViewController: UITableViewController
//@property (weak, nonatomic) IBOutlet UILabel *testFavorites;

@property (nonatomic, strong) NSArray *rowsInTheSQLiteDatabase;
//- (IBAction)resetFavoriteCount:(id)sender;

@end
