//
//  ViewController.m
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import "UserTimelineViewController.h"
#import "TwitterDetailViewController.h"
#import "UserTimeLineModel.h"
#import "MBProgressHUD.h"
#import "TTTAttributedLabel.h"
#import "UserTimelineCell.h"
#import "UserTimelineImageCell.h"
#import "SystemLevelConstants.h"
#import "ServiceManager.h"
#import "AppDelegate.h"

@interface UserTimelineViewController ()<UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate,UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITableView            *tableView;
@property (nonatomic, strong) ServiceManager                *serviceManager;
@property (nonatomic, strong) NSMutableArray                *timeLineArray;

@end

@implementation UserTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
    [self setupTableView];
}

#pragma mark - Initial setup methods
- (void)initialSetup
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.twitterTokenDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.timeLineArray.count == 0)
    {
        NSLog(@"progress hud");
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    [self initialServiceCall];
}

- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 40.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)initialServiceCall
{
    if(self.screen_name)
    {
        self.serviceManager = [ServiceManager defaultServiceManager];
        [self.serviceManager userTimeLine:self.screen_name withResponseData:^(NSDictionary *dictionary, NSError *error) {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf updateTableView:strongSelf withData:dictionary];
            });
        }];
    }
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.timeLineArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserTimeLineModel *userModel = self.timeLineArray[indexPath.row];
    if(userModel.mediaInfo!=nil)
        return [self configureUserTimelineImageCellWith:userModel AtIndexPath:indexPath];
    else
        return [self configureUserTimelineCellWith:userModel AtIndexPath:indexPath];
}


#pragma mark - UITableViewDataSourceHelper methods
- (UserTimelineCell *)configureUserTimelineCellWith:(UserTimeLineModel *)userModel AtIndexPath:(NSIndexPath *)indexPath
{
    UserTimelineCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserTimelineCell class]) forIndexPath:indexPath];
    [cell configureCell:userModel atIndexPath:indexPath];
    cell.lblMessage.delegate = self;
    return cell;
}


- (UserTimelineImageCell *)configureUserTimelineImageCellWith:(UserTimeLineModel *)userModel AtIndexPath:(NSIndexPath *)indexPath
{
    UserTimelineImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserTimelineImageCell class]) forIndexPath:indexPath];
    [cell configureCell:userModel atIndexPath:indexPath];
    cell.lblMessage.delegate = self;
    return cell;
}

#pragma mark - UITableViewDelegate methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterDetailViewController *twitterDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([TwitterDetailViewController class])];
    twitterDetailViewController.userModel = self.timeLineArray[indexPath.row];
    [self.navigationController pushViewController:twitterDetailViewController animated:YES];
}


#pragma mark - TwitterTokenProtocol methods
- (void)twitterTokenDownloaded:(NSDictionary *)dataDictionary
{
    
    kAccessToken = [dataDictionary objectForKey:@"access_token"];
    self.serviceManager = [ServiceManager defaultServiceManager];
    [self.serviceManager userTimeLine:@"tim_cook" withResponseData:^(NSDictionary *dictionary, NSError *error) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf updateTableView:strongSelf withData:dictionary];
        });
    }];
    
}

#pragma mark - Helper methods
- (void)updateTableView:(UserTimelineViewController *)strongSelf withData:(NSDictionary *)dictionary
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    strongSelf.timeLineArray = [dictionary objectForKey:@"user_timeline"];
    [strongSelf.tableView reloadData];
}


#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex)
        return;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
