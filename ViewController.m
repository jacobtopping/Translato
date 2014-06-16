//
//  ViewController.m
//  Translato
//
//  Created by Jacob Topping on 12-10-25.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Translation.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize categoryWord;
@synthesize subCategoryWord;
@synthesize EnglishWord;
@synthesize ItalianWord;
@synthesize phraseAt;

@synthesize english;
@synthesize wordId;
@synthesize player;
@synthesize translation;


- (void) didTapBackButton:(id)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)playSoundForCurrentCard {
	if (self.player.playing) {
		[self.player stop];
		self.player = nil;
	}
	

	//FlashCardData *fc = [self.content objectAtIndex:index];
    
	//NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	//int audioOption = [prefs integerForKey:@"audioOption"];
	NSString *soundFileName;
	//if (audioOption == 1) { // English
	//	soundFileName = fc.english;
	//} else if (audioOption == 2) { // Mandarin
//		soundFileName = [fc.english stringByAppendingString:@"-m"];
//	} else if (audioOption == 3) { // Cantonese
//		soundFileName = [fc.english stringByAppendingString:@"-c"];
//	} else {
//		soundFileName = nil;
//	}

    soundFileName = translation.itSound;
	
	if (soundFileName != nil) {
		NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundFileName ofType:@"mp3"];
		if (soundFilePath) {
			NSURL *url = [NSURL fileURLWithPath:soundFilePath];
            
			self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
			[self.player setNumberOfLoops:0];
			[self.player play];	
		}
	}
}

- (void)playSoundForCurrentCardEnglish {
	if (self.player.playing) {
		[self.player stop];
		self.player = nil;
	}
	
    
	//FlashCardData *fc = [self.content objectAtIndex:index];
    
	//NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	//int audioOption = [prefs integerForKey:@"audioOption"];
	NSString *soundFileName;
	//if (audioOption == 1) { // English
	//	soundFileName = fc.english;
	//} else if (audioOption == 2) { // Mandarin
    //		soundFileName = [fc.english stringByAppendingString:@"-m"];
    //	} else if (audioOption == 3) { // Cantonese
    //		soundFileName = [fc.english stringByAppendingString:@"-c"];
    //	} else {
    //		soundFileName = nil;
    //	}
    
    soundFileName = translation.engSound;
	
	if (soundFileName != nil) {
		NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:soundFileName ofType:@"mp3"];
		if (soundFilePath) {
			NSURL *url = [NSURL fileURLWithPath:soundFilePath];
            
			self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
			[self.player setNumberOfLoops:0];
			[self.player play];	
		}
	}
}

- (void)makeAFavorite {
    //do something with NS Userdefaults
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *favorites = [[prefs objectForKey:@"favorites"] mutableCopy];
    if (favorites == nil) {
        favorites = [[NSMutableArray alloc] init];
    }
    
    NSLog(@"This is displaying the translation.wordId %d", [translation.wordId intValue]); //intValue is a method of the NSNumber class...
    //NSNumber *idNumber = translation.wordId; // this forces translation.wordId to be an NSNumber, idNumber is a made-up variable.
    NSString *idNumber = translation.wordId;
    [favorites addObject:idNumber];
    
    [prefs setObject:favorites forKey:@"favorites"];
    
    [prefs synchronize]; // forces to save the prefs for next time. Otherwise it only sometimes autosaves... 
    
}

- (void)viewDidLoad
{
    
    
    /*
    if (english == nil) {
        english = @" 1";
    }
    */
    if (wordId == nil) {
        wordId = @"1";
    }
   
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"wordId = %@", wordId]; // this is essentially a filter... 
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    // Test listing all FlashCardDatas from the store
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Translation" 
											  inManagedObjectContext:context];
    NSError *error;
    
	[fetchRequest setEntity:entity];
	//NSSortDescriptor *sortGroup = [[NSSortDescriptor alloc] initWithKey:@"cat" ascending:YES];	
	//NSSortDescriptor *sortOrder = [[NSSortDescriptor alloc] initWithKey:@"sub" ascending:YES];
	[fetchRequest setPredicate:predicate];
    //[fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortGroup, sortOrder, nil]];
	NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];  
   
    //this sets the background of the main screen
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhone4S-background.png"]];
    self.view.backgroundColor = [UIColor clearColor];
    
    //this sets the background of the top navigation controller menu
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"top-menu-wood-background"] forBarMetrics: UIBarMetricsDefault];
    
    //this sets the text color of the top navigation controller menu.
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:UITextAttributeTextColor];
    
    //change back button image... 
    if(self.navigationController.viewControllers.count > 1) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(didTapBackButton:) forControlEvents:UIControlEventTouchUpInside];
        backButton.frame = CGRectMake(0.0f, 0.0f, 64.0f, 41.0f);
        backButton.titleLabel.textColor = [UIColor colorWithRed:96.0/255.0 green:57.0/255.0 blue:19.0/255.0 alpha:1.0]; // created this line myself... ohh ahhh!
        UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        
        self.navigationItem.leftBarButtonItem = backButtonItem;
    }
    
    //NSArray *nextword = 0;
    self.translation = [fetchedObjects objectAtIndex:0];
    
    NSLog(@"Fetched data: cat=%@, sub=%@, eng=%@, itali=%@, wordId=%@", translation.cat, translation.sub, translation.eng, translation.itali, translation.wordId); //this is not seeing the wordId... Why not?

    
    categoryWord.text=translation.cat;
    subCategoryWord.text=translation.sub;
    EnglishWord.text=translation.eng;
    ItalianWord.text=translation.itali;
    
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iPhone4S-background.png"]];
    //self.tableView.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setEnglishWord:nil];
    [self setItalianWord:nil];
    [self setPhraseAt:nil];
    [self setSubCategoryWord:nil];
    [self setCategoryWord:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)getAPhrase:(id)sender {
    
    
}
- (IBAction)playTranslation:(id)sender {
    [self playSoundForCurrentCard];
}
- (IBAction)playEnglishTranslation:(id)sender {
    [self playSoundForCurrentCardEnglish];
}

- (IBAction)makeFavorite:(id)sender {
    [self makeAFavorite];
}
@end
