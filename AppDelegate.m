//
//  AppDelegate.m
//  Translato
//
//  Created by Jacob Topping on 12-10-25.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "Translation.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSManagedObjectContext *context = [self managedObjectContext];
	NSError *error;
	Translation *translation;
    
    // Test listing all FlashCardDatas from the store
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Translation" 
											  inManagedObjectContext:context];
    
	[fetchRequest setEntity:entity];
    
	NSArray *rowsInTheSQLiteDatabase = [context executeFetchRequest:fetchRequest error:&error];  //this is an array of the objects (aka the rows in the database)...
    
    if ([rowsInTheSQLiteDatabase count] > 0) {
        return YES;
    }
	
	
	// Load translation data from a CSV file
	NSString *csvFileName = [[NSBundle mainBundle] pathForResource:@"italian-english" ofType:@"csv"];
    
    if ( csvFileName != nil ) {
		NSString *csvContent = [[NSString alloc] initWithContentsOfFile:csvFileName
                                                           usedEncoding:nil
                                                                  error:nil];
		
		NSScanner *scanner = [NSScanner scannerWithString:csvContent];
		[scanner setCharactersToBeSkipped:
         [NSCharacterSet characterSetWithCharactersInString:@""]];
        
        // cat= Category, Sub = Sub Category, eng = English, ital = Italian
		NSString *Id, *cat, *sub, *eng, *ital, *itCat, *itSub, *itSound, *engSound, *skip;
		int order;
		order = 1;
		
		while (   [scanner scanUpToString:@"," intoString:&Id] 
			   && [scanner scanString:@"," intoString:&skip]
			   && [scanner scanUpToString:@"," intoString:&cat]
			   && [scanner scanString:@"," intoString:&skip]
			   && [scanner scanUpToString:@"," intoString:&sub]
			   && [scanner scanString:@"," intoString:&skip]
			   && [scanner scanUpToString:@"," intoString:&eng]
			   && [scanner scanString:@"," intoString:&skip]
			   && [scanner scanUpToString:@"," intoString:&ital]
               
               && [scanner scanString:@"," intoString:&skip]
			   && [scanner scanUpToString:@"," intoString:&itCat]
               && [scanner scanString:@"," intoString:&skip]
			   && [scanner scanUpToString:@"," intoString:&itSub]
               && [scanner scanString:@"," intoString:&skip]
			   && [scanner scanUpToString:@"," intoString:&itSound]
               && [scanner scanString:@"," intoString:&skip]
			   && [scanner scanUpToString:@"\r\n" intoString:&engSound]
               && [scanner scanString:@"\r\n" intoString:&skip]
               ) {
			            
            
			// Insert new object to hold the data
			translation = [NSEntityDescription
							 insertNewObjectForEntityForName:@"Translation" 
							 inManagedObjectContext:context];
            
			//translation.wordId = [NSNumber numberWithInt:[Id intValue]];
            translation.wordId = Id;
            translation.cat = cat;
            translation.sub = sub;
            translation.eng = eng;
            translation.itali = ital;
            translation.itCat = itCat;
            translation.itSub = itSub;
            translation.itSound = itSound;
            translation.engSound = engSound;

            
            
			NSLog(@"Id: %@, cat: %@, sub: %@, eng: %@, ital: %@", Id, cat, sub, eng, ital);
            
            
			if (![context save:&error]) {
				NSLog(@"---ERROR---- Couldn't save row into database: %@", [error localizedDescription]);
			}
		
            
            
			// Skip the \n we scanned up to
			[scanner scanString:@"\n" intoString:&skip];
		}
	}
	

    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TranslatoDataModel" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Translato.sqlite"];
	//NSString *storePath = [storeURL path];
	
	// Copy the blank database from the resources folder into place, so we start from scratch every time
	/*NSFileManager *fileManager = [NSFileManager defaultManager];
	if ([fileManager fileExistsAtPath:storePath]) {
		[fileManager removeItemAtPath:storePath error:NULL];
	}
	
	NSString *defaultStorePath = [[NSBundle mainBundle] 
                                  pathForResource:@"Translato" ofType:@"sqlite"];
	if (defaultStorePath) {
		[fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
	}*/
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
