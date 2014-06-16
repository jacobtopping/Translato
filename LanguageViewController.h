//
//  LanguageViewController.h
//  Translato
//
//  Created by Jacob Topping on 12-11-19.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LanguageViewController : UIViewController
- (IBAction)EnglishToItalian:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *LanguageSelector;

@end
