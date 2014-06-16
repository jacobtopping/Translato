//
//  SearchViewController.h
//  Translato
//
//  Created by Jacob Topping on 12-11-19.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController  : UITableViewController <UISearchBarDelegate>

@property (nonatomic, strong) NSArray *rowsInTheSQLiteDatabase;
@property (weak, nonatomic) IBOutlet UITableView *SearchTableviewReload;

@end
