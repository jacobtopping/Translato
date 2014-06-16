//
//  SubCatCellsTableViewController.h
//  Translato
//
//  Created by Jacob Topping on 12-11-14.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubCatCellsTableViewController : UITableViewController


//@property (nonatomic, strong) NSArray *rows;
@property (nonatomic, strong) NSString *category;

@property (nonatomic, strong) NSArray *rowsInTheSQLiteDatabase;
@end
