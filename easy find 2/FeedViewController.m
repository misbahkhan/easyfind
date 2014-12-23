//
//  FeedViewController.m
//  easy find 2
//
//  Created by Misbah Khan on 12/21/14.
//  Copyright (c) 2014 Misbah Khan. All rights reserved.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>

@interface FeedViewController ()
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) UIRefreshControl *refresh;
@end

@implementation FeedViewController

- (void) viewDidAppear:(BOOL)animated
{
    if (![PFUser currentUser]) {
        [self.navigationController performSegueWithIdentifier:@"login" sender:self]; 
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:0.47 blue:1 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    _refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(refreshtable) forControlEvents:UIControlEventValueChanged];
    [_table addSubview:_refresh];
    // Do any additional setup after loading the view.
}

- (void) refreshtable
{
    [_refresh endRefreshing]; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
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
