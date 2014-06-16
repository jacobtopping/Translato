//
//  ViewController.h
//  Translato
//
//  Created by Jacob Topping on 12-10-25.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVFoundation/AVAudioPlayer.h>
#import "Translation.h"

@interface ViewController : UIViewController {
    AVAudioPlayer *player;
    Translation *translation;
}
@property (retain) AVAudioPlayer *player;

@property (weak, nonatomic) IBOutlet UILabel *categoryWord;
@property (weak, nonatomic) IBOutlet UILabel *subCategoryWord;
@property (weak, nonatomic) IBOutlet UILabel *EnglishWord;
@property (weak, nonatomic) IBOutlet UILabel *ItalianWord;
@property (weak, nonatomic) IBOutlet UITextField *phraseAt;

@property (strong,nonatomic) Translation *translation;

- (IBAction)getAPhrase:(id)sender;

@property (strong, nonatomic) NSString *english;
//@property (strong, nonatomic) NSNumber *wordId;
@property (strong, nonatomic) NSString *wordId;
- (IBAction)playTranslation:(id)sender;
- (IBAction)playEnglishTranslation:(id)sender;

- (IBAction)makeFavorite:(id)sender;

@end
