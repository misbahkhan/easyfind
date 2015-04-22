//
//  shared.h
//  easy find 2
//
//  Created by Misbah Khan on 2/7/15.
//  Copyright (c) 2015 Misbah Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface shared : NSObject

@property (nonatomic, retain) PFObject *currentproject;
@property (nonatomic) UIImagePickerControllerSourceType source;
@property (nonatomic, retain) NSDictionary *pictureinfo; 

+(id) instance;
-(void) getimagecount:(PFObject *)project
         onCompletion:(void (^)(int count))done;

-(void) getallimages:(PFObject *)project
        onCompletion:(void (^)(NSMutableDictionary *images))done;

@end
