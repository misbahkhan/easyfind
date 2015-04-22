//
//  FeedViewController.m
//  easy find 2
//
//  Created by Misbah Khan on 12/21/14.
//  Copyright (c) 2014 Misbah Khan. All rights reserved.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "shared.h"

@interface FeedViewController (){
    NSMutableArray *projects;
    NSMutableDictionary *images;
    shared *data;
}
@property (strong, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) UIRefreshControl *refresh;
@end

@implementation FeedViewController

- (void) viewDidAppear:(BOOL)animated
{
    if (![PFUser currentUser]) {
        [self.navigationController performSegueWithIdentifier:@"login" sender:self]; 
    }
    [self getallprojects];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0 green:0.47 blue:1 alpha:1]];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    _refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(refreshtable) forControlEvents:UIControlEventValueChanged];
    [_table addSubview:_refresh];
    
    images = [[NSMutableDictionary alloc] init];
    
    self.table.contentInset = UIEdgeInsetsMake(0,0,44,0);
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self getallprojects];
    
    data = [shared instance];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [projects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 168.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *project = (PFObject *)[projects objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"projectcell"];
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    UIImageView *imageview = (UIImageView *)[cell viewWithTag:2];
    imageview.layer.cornerRadius = 5.0f;
    imageview.clipsToBounds = YES;
    label.text = [[projects objectAtIndex:indexPath.row] objectForKey:@"title"];

//    if (imageview.image == nil) {
        if ([images objectForKey:project.objectId] != nil) {
            imageview.image = [images objectForKey:project.objectId];
        }
//    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_refresh isRefreshing]) return;
    PFObject *project = [projects objectAtIndex:indexPath.row];
    data.currentproject = project;
    [self performSegueWithIdentifier:@"project" sender:self]; 
}

- (void) getallprojects
{
    [projects removeAllObjects];
    [_refresh beginRefreshing];
    PFQuery *query = [PFQuery queryWithClassName:@"Projects"];
    [query whereKey:@"Owner" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            projects = [objects mutableCopy];
            [self.table reloadData];
            if (objects.count < 1) {
                [self noprojects];
            }
            NSLog(@"Successfully retrieved %d projects.", (int)objects.count);
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        [self getallimages];
    }];
}

- (void) noprojects
{
    [_refresh endRefreshing];
}

- (void) getallimages
{
    [images removeAllObjects];
    for (PFObject *project in projects) {
        PFFile *userImageFile = project[@"mapImage"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                [images setObject:image forKey:project.objectId];
                [_table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[projects indexOfObject:project] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                if ([images count] == [projects count]) {
                    [self endrefresh];
                }
            }
        }];
    }
}

- (void) endrefresh
{
    [_refresh endRefreshing];
}

- (void) refreshtable
{
    [self getallprojects];
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
