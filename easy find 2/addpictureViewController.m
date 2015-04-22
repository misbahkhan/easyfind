//
//  addpictureViewController.m
//  easy find 2
//
//  Created by Misbah Khan on 3/26/15.
//  Copyright (c) 2015 Misbah Khan. All rights reserved.
//

#import "addpictureViewController.h"
#import "shared.h"

@interface addpictureViewController (){
    shared *data;
    IBOutlet UIImageView *image;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UIButton *addbutton;
    IBOutlet UIView *addingpicture;
}

@end

@implementation addpictureViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    data = [shared instance];
    activity.hidesWhenStopped = YES;
    // Do any additional setup after loading the view.

}

- (void) viewDidAppear:(BOOL)animated
{
    if(data.pictureinfo){
        NSLog(@"%@", data.pictureinfo);
        image.image = [data.pictureinfo objectForKey:UIImagePickerControllerEditedImage];
    }
}

- (IBAction)addpicture:(id)sender {
    addbutton.hidden = YES;
    addingpicture.hidden = NO;
    [activity startAnimating];

    
    UIImage *toupload = image.image;
    NSData *upload = UIImagePNGRepresentation(toupload);
    
    PFFile *pic = [PFFile fileWithName:@"image" data:upload];
    PFObject *file = [PFObject objectWithClassName:@"Files"];
    file[@"project"] = data.currentproject;
    file[@"file"] = pic;
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
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
