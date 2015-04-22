//
//  projectViewController.m
//  easy find 2
//
//  Created by Misbah Khan on 2/7/15.
//  Copyright (c) 2015 Misbah Khan. All rights reserved.
//

#define CAMERA 0
#define GALLERY 1

#import "projectViewController.h"
#import "shared.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>

@interface projectViewController (){
    shared *data;
    PFObject *project;
    IBOutlet MKMapView *map;
    UIActionSheet *options;
    UIImagePickerController *picker;
    IBOutlet UICollectionView *collection;
    NSMutableArray *imagekeys;
    NSMutableDictionary *images;
}

@end

@implementation projectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data = [shared instance];
    project = data.currentproject;
    
    self.title = project[@"title"];
    
    PFGeoPoint *geo = project[@"location"];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(geo.latitude, geo.longitude), 800, 800);
    [map setRegion:[map regionThatFits:region] animated:YES];
    // Do any additional setup after loading the view.
    options = [[UIActionSheet alloc] initWithTitle:nil
                                          delegate:self
                                 cancelButtonTitle:@"Cancel"
                            destructiveButtonTitle:nil
                                 otherButtonTitles:@"Take Picture", @"Choose from Pictures", nil];
    
    [collection setBackgroundColor:[UIColor clearColor]];
    
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;

    imagekeys = [[NSMutableArray alloc] init];
    images = [[NSMutableDictionary alloc] init];
    
    [self getallimages];
    
//    [data getimagecount:data.currentproject onCompletion:^(int count) {
//        imagecount = count;
//        [data getallimages:data.currentproject onCompletion:^(NSMutableDictionary *_images) {
//            images = [_images mutableCopy];
//            imagenumerator = [images objectEnumerator];
//            [collection reloadData];
//            NSLog(@"Done loading images"); 
//        }];
//    }];
}

- (void) getallimages
{
    [imagekeys removeAllObjects];
    PFQuery *findfiles = [PFQuery queryWithClassName:@"Files"];
    [findfiles whereKey:@"project" equalTo:project];
    [findfiles findObjectsInBackgroundWithBlock:^(NSArray *pictures, NSError *error) {
        if (!error) {
            for (PFObject *pic in pictures) {
                 [imagekeys addObject:pic.objectId];
                [collection reloadData];
            }
            
            for (PFObject *pic in pictures) {
                PFFile *projectimage = pic[@"file"];
                [projectimage getDataInBackgroundWithBlock:^(NSData *picdata, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:picdata];
                        [images setObject:image forKey:pic.objectId];
                        NSUInteger index = [imagekeys indexOfObject:pic.objectId];
                        NSIndexPath *path = [NSIndexPath indexPathForRow:index inSection:0];
//                        [collection reloadItemsAtIndexPaths:@[path]];
                        if (pic == [pictures lastObject]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [collection reloadData];
                            });
                        }
                    }
                }];
            }
        } else {
            // TODO: failed
        }
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [imagekeys count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"picturecell" forIndexPath:indexPath];
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:1];
    
    NSString *key = [imagekeys objectAtIndex:indexPath.row];
    
    if ([images objectForKey:key] != nil) {
        imageview.image = [images objectForKey:key];
    }
    
    return cell;
}

- (void) viewDidAppear:(BOOL)animated
{

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == CAMERA) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if (buttonIndex == GALLERY) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        return;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    data.pictureinfo = info;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSLog(@"picked: %@", info);
    [self performSegueWithIdentifier:@"addpicture" sender:self];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)camerabutton:(id)sender {
    [options showInView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
