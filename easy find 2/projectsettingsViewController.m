//
//  projectsettingsViewController.m
//  easy find 2
//
//  Created by Misbah Khan on 2/7/15.
//  Copyright (c) 2015 Misbah Khan. All rights reserved.
//

#import "projectsettingsViewController.h"
#import "shared.h"
#import <Parse/Parse.h>

@interface projectsettingsViewController (){
    shared *data;
    PFObject *project;
}

@end

@implementation projectsettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    data = [shared instance];
    project = data.currentproject;
    
    self.title = [NSString stringWithFormat:@"%@ settings", project[@"title"]];
    
    // Do any additional setup after loading the view.
}

- (IBAction)deleteproject:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Confirm Delete"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:@"Delete"
                                                    otherButtonTitles:nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [project deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
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
