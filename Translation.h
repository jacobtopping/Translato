//
//  Translation.h
//  Translato
//
//  Created by Jacob Topping on 12-10-25.
//  Copyright (c) 2012 The Melon Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Translation : NSManagedObject

//@property (nonatomic, retain) NSNumber * wordId;
@property (nonatomic, retain) NSString * wordId;
@property (nonatomic, retain) NSString * cat;
@property (nonatomic, retain) NSString * sub;
@property (nonatomic, retain) NSString * eng;
@property (nonatomic, retain) NSString * itali;
@property (nonatomic, retain) NSString * itCat;
@property (nonatomic, retain) NSString * itSub;
@property (nonatomic, retain) NSString * itSound;
@property (nonatomic, retain) NSString * engSound;

@end
