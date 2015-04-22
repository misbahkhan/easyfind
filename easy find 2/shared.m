//
//  shared.m
//  easy find 2
//
//  Created by Misbah Khan on 2/7/15.
//  Copyright (c) 2015 Misbah Khan. All rights reserved.
//

#import "shared.h"
#import <Parse/Parse.h>

@implementation shared

+ (id)instance {
    static shared *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (id)init {
    if (self = [super init]) {
        self.currentproject = nil;
    }
    return self;
}

- (void) getimagecount:(PFObject *)project onCompletion:(void (^)(int))done
{
    PFQuery *countfiles = [PFQuery queryWithClassName:@"Files"];
    [countfiles whereKey:@"project" equalTo:project];
    [countfiles countObjectsInBackgroundWithBlock:^(int count, NSError *error) {
        if (!error) {
            done(count); 
        } else {
            // The request failed
        }
    }];
}
- (void) getallimages:(PFObject *)project onCompletion:(void (^)(NSMutableDictionary *images))done
{
    NSMutableDictionary *images = [[NSMutableDictionary alloc] init];
    PFQuery *findfiles = [PFQuery queryWithClassName:@"Files"];
    [findfiles whereKey:@"project" equalTo:project];
    [findfiles findObjectsInBackgroundWithBlock:^(NSArray *pictures, NSError *error) {
        if (!error) {
            for (PFObject *pic in pictures) {
                PFFile *projectimage = pic[@"file"];
                [projectimage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        [images setObject:image forKey:pic.objectId];
                        if (pic == [pictures lastObject]) {
                            done(images);
                        }
                    }
                }];
            }
        } else {
            // TODO: failed
        }
    }];
}

//- (void) getallimages:(PFObject *)project:(void (^)(NSMutableDictionary * images))done
//{
//    
//    for (PFObject *project in projects) {
//        PFFile *userImageFile = project[@"mapImage"];
//        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//            if (!error) {
//                UIImage *image = [UIImage imageWithData:imageData];
//                [images setObject:image forKey:project.objectId];
//                [_table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[projects indexOfObject:project] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                if ([images count] == [projects count]) {
//                    [self endrefresh];
//                }
//            }
//        }];
//    }
//}

@end
