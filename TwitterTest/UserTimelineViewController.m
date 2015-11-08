//
//  ViewController.m
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/6/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import "UserTimelineViewController.h"
#import "UserTimeLineModel.h"
#import "UserTimelineCell.h"
#import "UserTimelineImageCell.h"
#import "SystemLevelConstants.h"
#import "ServiceManager.h"
#import "AppDelegate.h"

@interface UserTimelineViewController ()<UITableViewDataSource,UITableViewDelegate>

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

- (void)setupTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 40.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
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
    return cell;
}


- (UserTimelineImageCell *)configureUserTimelineImageCellWith:(UserTimeLineModel *)userModel AtIndexPath:(NSIndexPath *)indexPath
{
    UserTimelineImageCell *cell = [self.tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserTimelineImageCell class]) forIndexPath:indexPath];
    [cell configureCell:userModel atIndexPath:indexPath];
    return cell;
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
    strongSelf.timeLineArray = [dictionary objectForKey:@"user_timeline"];
    [strongSelf.tableView reloadData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
