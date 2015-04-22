//
//  AddProjectViewController.m
//  easy find 2
//
//  Created by Misbah Khan on 12/22/14.
//  Copyright (c) 2014 Misbah Khan. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

#import "AddProjectViewController.h"

@interface AddProjectViewController (){
    IBOutlet MKMapView *map;
    CLLocationManager *location;
    IBOutlet UIButton *addproject;
    IBOutlet UITextField *projecttitle;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIView *loading;
}

@end

@implementation AddProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    projecttitle.delegate = self; 
    
    addproject.enabled = NO;
    
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    map.layer.cornerRadius = 5.0f;
    
    location = [[CLLocationManager alloc] init];
    
    [location requestWhenInUseAuthorization];
    location.delegate = self;
    [location startUpdatingLocation];
    map.showsUserLocation = YES;
    map.delegate = self;
    // Do any additional setup after loading the view.
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([[textField text] length] > 0) {
        addproject.enabled = true;
    } else {
        addproject.enabled = false;
    }
    return true;
}
- (IBAction)addproject:(id)sender {
    loading.hidden = NO;
    [activity startAnimating];
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    options.region = map.region;
    options.scale = [UIScreen mainScreen].scale;
    options.size = map.frame.size;
    
    
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        UIImage *image = snapshot.image;
        NSData *data = UIImagePNGRepresentation(image);

        PFFile *upload = [PFFile fileWithName:@"image" data:data];
        PFObject *project = [PFObject objectWithClassName:@"Projects"];
        project[@"mapImage"] = upload;
        project[@"Owner"] = [PFUser currentUser];
        project[@"title"] = [projecttitle text];
        PFGeoPoint *loc = [PFGeoPoint geoPointWithLocation:[location location]];
        project[@"location"] = loc;
        [project saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self pop];
        }];
    }];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [map setRegion:[map regionThatFits:region] animated:YES];
}

- (void) pop {
    [self.navigationController popViewControllerAnimated:YES];
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
