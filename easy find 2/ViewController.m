//
//  ViewController.m
//  easy find 2
//
//  Created by Misbah Khan on 12/20/14.
//  Copyright (c) 2014 Misbah Khan. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UILabel *error;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)login:(id)sender {
    [PFUser logInWithUsernameInBackground:[_username text] password:[_password text]
        block:^(PFUser *user, NSError *error) {
            [self nextstep:error];
        }];
}

- (IBAction)signup:(id)sender {
    PFUser *user = [PFUser user];
    user.username = [_username text];
    user.password = [_password text];
    user.email = [_username text];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self nextstep:error];
    }];
}

- (void) nextstep:(NSError *)error
{
    if (!error) {
        [self performSegueWithIdentifier:@"in" sender:self];
    } else {
        [_error setText:[error userInfo][@"error"]];
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
