//
//  ChatlistViewController.m
//  vanke
//
//  Created by zengwu on 13-7-1.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "ChatlistViewController.h"
#import "UIImage+PImageCategory.h"
#import "FriendCell.h"
#import "RunUser.h"
#import "UserSessionManager.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "ChatViewController.h"
#import "FriendInfo.h"
#import "SettingViewController.h"
#import "PCommonUtil.h"

@interface ChatlistViewController ()

@end

@implementation ChatlistViewController

@synthesize navView = _navView;
@synthesize friendTableView = _friendTableView;
@synthesize indicatorView = _indicatorView;

@synthesize unReadFriendList = _unReadFriendList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"未读消息列表" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *indexHeadBg = [UIImage imageWithName:@"main_head" type:@"png"];
    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
    [_navView.rightButton setHidden:NO];
    
    //tableview
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [bgImageView setFrame:CGRectMake(0, 0, 320, height - 44)];
    [bgImageView setImage:[UIImage imageWithName:@"run_bg" type:@"png"]];
    _friendTableView.backgroundColor = [UIColor clearColor];
    _friendTableView.backgroundView = bgImageView;
    _friendTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _friendTableView.frame = CGRectMake(0, 44, 320, height - 44);
    
    //data
    _unReadFriendList = [[NSMutableArray alloc] init];
    
    //from net
    [self initData];
    [self getInviteData];
}

-(void)getInviteData{
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *msgListUrl = [VankeAPI getInviteListUrl:memberid :1 :10];
    NSLog(@"msgList:%@",msgListUrl);
    NSURL *url = [NSURL URLWithString:msgListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            if (datalistCount>0) {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:[NSString stringWithFormat:@"您有%d条邀请，请查看！",datalistCount] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
                [alert show];
            }
            
            //            ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
            //            [chatViewController setChatType:chatTYpeInviteCheck];
            //            [self.navigationController pushViewController:chatViewController animated:YES];
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = errMsg;
            hud.margin = 10.f;
            hud.yOffset = 150.0f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex:%d",buttonIndex);
    if (buttonIndex==1) {
        ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
        [chatViewController setChatType:chatTypeInviteCheck];
        [self.navigationController pushViewController:chatViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)initData{
    
    [_indicatorView startAnimating];
    
    NSString *memberid = [UserSessionManager GetInstance].currentRunUser.userid;
    NSString *fanListUrl = [VankeAPI getUnreadList:memberid];
//    NSLog(@"fanListUrl:%@",fanListUrl);
    NSURL *url = [NSURL URLWithString:fanListUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSArray *datalist = [dicResult objectForKey:@"list"];
            int datalistCount = [datalist count];
            for (int i=0; i<datalistCount; i++) {
                NSDictionary *dicrecord = [datalist objectAtIndex:i];
                FriendInfo *friendinfo = [FriendInfo initWithNSDictionary:dicrecord];
                [_unReadFriendList addObject:friendinfo];
            }
            
            [_friendTableView reloadData];
        }else{
            NSString *errMsg = [dicResult objectForKey:@"msg"];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = errMsg;
            hud.margin = 10.f;
            hud.yOffset = 150.0f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:2];
        }
        
        if(_indicatorView.isAnimating){
            [_indicatorView stopAnimating];
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
        
        if(_indicatorView.isAnimating){
            [_indicatorView stopAnimating];
        }
        
    }];
    [operation start];
    
}

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"_unReadFriendListCount:%d",[_unReadFriendList count]);
    return [_unReadFriendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"FriendTableCell";
	FriendCell *cell = (FriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:self options:nil];
        cell = (FriendCell *)[nibContents objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
    
    FriendInfo *friendinfo = [_unReadFriendList objectAtIndex:indexPath.row];
    
    if ([PCommonUtil checkDataIsNull:friendinfo.fromNickName]) {
        cell.lblNickname.text = friendinfo.fromNickName;
    }
    cell.lblTime.text = friendinfo.fromLoginTime;
    cell.btnChat.tag = indexPath.row;
    [cell.btnChat addTarget:self action:@selector(doGotoChat:) forControlEvents:UIControlEventTouchUpInside];
    
	return cell;
}

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 57;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendInfo *friendinfo = [_unReadFriendList objectAtIndex:indexPath.row];
    
    SettingViewController *settingViewController = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    [settingViewController setMemberid:friendinfo.fromMemberID];
    [self.navigationController pushViewController:settingViewController animated:YES];
    
}

-(void)doGotoChat:(id)sender{
    
    UIButton *chatButton = sender;
    FriendInfo *friendinfo = [_unReadFriendList objectAtIndex:chatButton.tag];
    
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [chatViewController setFriendInfo:friendinfo];
    [self.navigationController pushViewController:chatViewController animated:YES];
    
}

@end
