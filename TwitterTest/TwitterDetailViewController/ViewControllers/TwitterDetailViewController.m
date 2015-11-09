//
//  TwitterDetailViewController.m
//  TwitterTest
//
//  Created by Raghav Sai Cheedalla on 11/7/15.
//  Copyright © 2015 Ecovent. All rights reserved.
//

#import "TwitterDetailViewController.h"
#import "UserTimelineViewController.h"
#import "BABFrameObservingInputAccessoryView.h"
#import "MBProgressHUD.h"
#import "UserTimeLineModel.h"
#import "TwitterDetailCell.h"
#import "TTTAttributedLabel.h"

@interface TwitterDetailViewController ()<UITableViewDataSource,UITableViewDelegate,TTTAttributedLabelDelegate,UIActionSheetDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView        *tableView;
@property (weak, nonatomic) IBOutlet UIView             *replyView;
@property (weak, nonatomic) IBOutlet UITextField        *txtSendField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolbarContainerVerticalSpacingConstraint;

@end

@implementation TwitterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialSetup];
}

- (void)initialSetup
{
    if(self.userModel)
    {
        [self setupTableView];
        [self setupTextField];
    }
    else
        [self showAlertView];
}

- (void)setupTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.estimatedRowHeight = 200.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)setupTextField
{
    self.txtSendField.delegate = self;
    BABFrameObservingInputAccessoryView *inputView = [[BABFrameObservingInputAccessoryView alloc] init];
    inputView.userInteractionEnabled = NO;
    self.txtSendField.inputAccessoryView = inputView;
    __weak typeof(self)weakSelf = self;
    inputView.keyboardFrameChangedBlock = ^(BOOL keyboardVisible, CGRect keyboardFrame){
        CGFloat value = CGRectGetMaxY(weakSelf.view.frame) - CGRectGetMinY(keyboardFrame);
        NSLog(@"%f,%f",CGRectGetMaxY(weakSelf.view.frame),CGRectGetMinY(keyboardFrame));
        weakSelf.toolbarContainerVerticalSpacingConstraint.constant = MAX(0, value);
        [weakSelf.view layoutIfNeeded];
    };
}

- (void)showAlertView
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Problem in retreiving Tweet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.userModel)
        return 1;
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TwitterDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TwitterDetailCell class]) forIndexPath:indexPath];
    [cell configureCell:self.userModel];
    cell.lblMessage.delegate = self;
    [cell.btnProfile addTarget:self action:@selector(showProfile) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}


#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if([self.userModel.messageInfo.message_User_Mentions containsObject:[url absoluteString]])
        [self handleClicked:[url absoluteString]];
    else
        [self showAlertController:url forLabelFrame:label];
}


#pragma mark - Utillity methods
- (void)showAlertController:(NSURL *)url forLabelFrame:(TTTAttributedLabel *)label
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[url absoluteString]
                                                                             message:@"Open link in Safari"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       NSLog(@"Cancel action");
                                   }];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [[UIApplication sharedApplication] openURL:url];
                               }];
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover)
    {
        popover.sourceView = label;
        popover.sourceRect = label.bounds;
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}


#pragma mark - Action methods
- (void)showProfile
{
    [self openProfile:self.userModel.userInfo.user_screen_name];
}

- (void)handleClicked:(NSString *)screenName
{
    [self openProfile:screenName];
}

- (IBAction)userViewTapped:(id)sender
{
    [self showProfile];
}

- (IBAction)sendAction:(id)sender
{
    [self.txtSendField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.txtSendField.text = @"";
    });
}

#pragma mark - UITextFieldDelegate methods
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = [NSString stringWithFormat:@"@%@",self.userModel.userInfo.user_screen_name];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(range.length + range.location > textField.text.length)
        return NO;
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 140;
}


#pragma mark - Helper methods
- (void)openProfile:(NSString *)screenName
{
    UserTimelineViewController *userTimeLineViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([UserTimelineViewController class])];
    userTimeLineViewController.screen_name = screenName;
    [self.navigationController pushViewController:userTimeLineViewController animated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
