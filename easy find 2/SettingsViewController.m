//
//  SettingsViewController.m
//  easy find 2
//
//  Created by Misbah Khan on 12/21/14.
//  Copyright (c) 2014 Misbah Khan. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController (){
    IBOutlet UILabel *username;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    username.text = [PFUser currentUser][@"username"]; 
    
    // Do any additional setup after loading the view.
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self.navigationController performSegueWithIdentifier:@"login" sender:self];
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
