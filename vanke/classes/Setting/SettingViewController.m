//
//  SettingViewController.m
//  vanke
//
//  Created by pig on 13-6-10.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import "SettingViewController.h"
#import "UIImage+PImageCategory.h"
#import "VankeAPI.h"
#import "AFJSONRequestOperation.h"
#import "UserSessionManager.h"
#import "TaskViewController.h"

#import "MBProgressHUD.h"

#import "FriendInfo.h"
#import "ChatViewController.h"
#import "UserSessionManager.h"

#import "GTMBase64.h"
#import "AFHTTPClient.h"

#import "UIImage+PImageCategory.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

@synthesize navView = _navView;

@synthesize tempScroll = _tempScroll;
@synthesize broadView = _broadView;
@synthesize avatarImageView = _avatarImageView;
@synthesize lblTotalDistance = _lblTotalDistance;
@synthesize lblDuiHuanDistance = _lblDuiHuanDistance;

@synthesize lblMingCi = _lblMingCi;
@synthesize lblHaoYou = _lblHaoYou;
@synthesize lblNengLiang = _lblNengLiang;
@synthesize lblDeFen = _lblDeFen;

@synthesize btnJiFen = _btnJiFen;
@synthesize btnDuoBao = _btnDuoBao;
@synthesize btnDuiHuanRecord = _btnDuiHuanRecord;

@synthesize tallField = _tallField;
@synthesize weightField = _weightField;
@synthesize areaField = _areaField;
@synthesize addressField = _addressField;
@synthesize telField = _telField;

@synthesize btnSina = _btnSina;
@synthesize btnTel = _btnTel;

@synthesize memberid = _memberid;

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
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    [bgImageView setFrame:CGRectMake(0, 0, 320, height)];
    [bgImageView setImage:[UIImage imageWithName:@"setting_bg" type:@"png"]];
    [self.view addSubview:bgImageView];
    
    _broadView.frame = CGRectMake(0, 0, 320, 548);
    
    _tempScroll = [[UIScrollView alloc] init];
    _tempScroll.frame = CGRectMake(0, 0, 320, height);
    _tempScroll.scrollEnabled = YES;
    _tempScroll.contentSize = CGSizeMake(320, 548);
    _tempScroll.delegate = self;
    [_tempScroll addSubview:_broadView];
    [self.view addSubview:_tempScroll];
    
    //nav bar
    _navView = [[PCustomNavigationBarView alloc] initWithTitle:@"设置(个人)" bgImageView:@"index_nav_bg"];
    [self.view addSubview:_navView];
    
    UIImage *indexBack = [UIImage imageWithName:@"main_back" type:@"png"];
    [_navView.leftButton setBackgroundImage:indexBack forState:UIControlStateNormal];
    [_navView.leftButton setHidden:NO];
    [_navView.leftButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
    
    long long currentMemberid = [[UserSessionManager GetInstance].currentRunUser.userid longLongValue];
     //如果是登录者进入设置，则显示保存按钮
    if (currentMemberid == _memberid) {
        UIImage *indexHeadBg = [UIImage imageWithName:@"setting_btn_save" type:@"png"];
        [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
//        [_navView.rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [_navView.rightButton setHidden:NO];
        [_navView.rightButton setFrame:CGRectMake(250, 7, 56, 29)];
        [_navView.rightButton addTarget:self action:@selector(touchMenuAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.btnJiFen setEnabled:YES];
        [self.btnDuoBao setEnabled:YES];
        [self.btnDuiHuanRecord setEnabled:YES];
        
        [self.tallField setEnabled:YES];
        [self.weightField setEnabled:YES];
        [self.areaField setEnabled:YES];
        [self.addressField setEnabled:YES];
        [self.telField setEnabled:YES];
    }else{
        NSString *setIsFanUrl = [VankeAPI getIsFanUrl:[UserSessionManager GetInstance].currentRunUser.userid :[NSString stringWithFormat:@"%ld",_memberid]];
        NSURL *url = [NSURL URLWithString:setIsFanUrl];
        NSLog(@"isFan:%@",setIsFanUrl);
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"App.net Global Stream: %@", JSON);
            NSDictionary *dicResult = JSON;
            NSString *status = [dicResult objectForKey:@"status"];
            NSLog(@"status: %@", status);
            if ([status isEqual:@"0"]) {
                NSLog(@"isFan：%d",[[dicResult objectForKey:@"isFan"] intValue]);
                if ([[dicResult objectForKey:@"isFan"] intValue] == 1) {
                    UIImage *indexHeadBg = [UIImage imageWithName:@"setting_btn_invit" type:@"png"];
                    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
                    [_navView.rightButton setTitle:@"聊天" forState:UIControlStateNormal];
                    [_navView.rightButton setHidden:NO];
                    [_navView.rightButton setFrame:CGRectMake(272, 9, 24, 25)];
                    [_navView.rightButton addTarget:self action:@selector(doGotoChat:) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    UIImage *indexHeadBg = [UIImage imageWithName:@"setting_btn_invit" type:@"png"];
                    [_navView.rightButton setBackgroundImage:indexHeadBg forState:UIControlStateNormal];
                    //        [_navView.rightButton setTitle:@"约跑" forState:UIControlStateNormal];
                    [_navView.rightButton setHidden:NO];
                    [_navView.rightButton setFrame:CGRectMake(272, 9, 24, 25)];
                    [_navView.rightButton addTarget:self action:@selector(doGotoInvite:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"failure: %@", error);
        }];
        [operation start];
        
        [self.btnJiFen setEnabled:NO];
        [self.btnDuoBao setEnabled:NO];
        [self.btnDuiHuanRecord setEnabled:NO];
        
        [self.tallField setEnabled:NO];
        [self.weightField setEnabled:NO];
        [self.areaField setEnabled:NO];
        [self.addressField setEnabled:NO];
        [self.telField setEnabled:NO];
    }
    
    UIImage *messageTip = [UIImage imageWithName:@"index_button_new" type:@"png"];
    [_navView.messageTipImageView setImage:messageTip];
//    [_navView.messageTipImageView setHidden:NO];
    
    //show data
    [self initData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initData{
    
    NSString *memberUrl = [VankeAPI getGetMemberUrl:[NSString stringWithFormat:@"%ld", _memberid]];
    NSURL *url = [NSURL URLWithString:memberUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"App.net Global Stream: %@", JSON);
        NSDictionary *dicResult = JSON;
        NSString *status = [dicResult objectForKey:@"status"];
        NSLog(@"status: %@", status);
        if ([status isEqual:@"0"]) {
            
            NSDictionary *dicEnt = [dicResult objectForKey:@"ent"];
            _runner = [RunUser initWithNSDictionary:dicEnt];
            
            _tallField.text = [NSString stringWithFormat:@"%.2f", _runner.tall];
            _weightField.text = [NSString stringWithFormat:@"%.2f", _runner.weight];
            _areaField.text = [NSString stringWithFormat:@"%d", _runner.communityid];
            _addressField.text = [NSString stringWithFormat:@"%@", _runner.address];
            _telField.text = [NSString stringWithFormat:@"%@", _runner.tel];
            
        }
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"failure: %@", error);
    }];
    [operation start];
    
}

-(void)doBack{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)touchMenuAction:(id)sender{
    
    //临时保存使用
    NSLog(@"SetInfo...");
    
    long long currentMemberid = [[UserSessionManager GetInstance].currentRunUser.userid longLongValue];
    if (currentMemberid != _memberid) {
        return;
    }
    
    NSString *strMemberid = [NSString stringWithFormat:@"%ld", _memberid];
    NSString *strTall = _tallField.text;
    NSString *strWeight = _weightField.text;
    NSString *strBirthday = @"2013-06-15";
    
    if (strTall && strTall.length >= 1 && strWeight && strWeight.length >= 1) {
        
        NSString *setInfoUrl = [VankeAPI getSetInfoUrl:strMemberid height:strTall weight:strWeight birthday:strBirthday];
        NSURL *url = [NSURL URLWithString:setInfoUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"App.net Global Stream: %@", JSON);
            NSDictionary *dicResult = JSON;
            NSString *status = [dicResult objectForKey:@"status"];
            NSLog(@"status: %@", status);
            if ([status isEqual:@"0"]) {
                NSLog(@"SetInfo successful...");
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                
                // Configure for text only and offset down
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"保存成功";
                hud.margin = 10.f;
                hud.yOffset = 0.f;
                hud.removeFromSuperViewOnHide = YES;
                
                [hud hide:YES afterDelay:3];
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"failure: %@", error);
        }];
        [operation start];
        
    }//end if
    if (changeHeadImg) {
        
        NSData *headData = UIImagePNGRepresentation(self.btnHeadImg.imageView.image);
        NSString *base64data = [[NSString alloc] initWithData:[GTMBase64 encodeData:headData] encoding:NSUTF8StringEncoding];
        
        NSLog(@"base64data: %@", base64data);
        
        NSString *uploadImageUrl = [VankeAPI getSetHeadImgUrl:strMemberid];
        
        NSDictionary *dicParam = [NSDictionary dictionaryWithObjectsAndKeys:base64data, @"headImg", nil];
        NSURL *url = [NSURL URLWithString:uploadImageUrl];
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:nil parameters:dicParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:headData name:@"headImg" fileName:@"headimg.jpg" mimeType:@"image/jpeg"];
        }];
        
        
        AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            NSLog(@"App.net Global Stream: %@", JSON);
            NSDictionary *dicResult = JSON;
            NSString *status = [dicResult objectForKey:@"status"];
            NSString *msg = [dicResult objectForKey:@"msg"];
            NSLog(@"status: %@, msg: %@", status, msg);
            if ([status isEqual:@"0"]) {
                
            }
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            NSLog(@"failure: %@", error);
        }];
        
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
        }];
        
        [operation start];
    }
}

-(void)doGotoInvite:(id)sender{
    NSLog(@"doGotoInvite...");
    
    FriendInfo *friendinfo = [[FriendInfo alloc]init];
    friendinfo.fromMemberID = [_runner.userid longLongValue];
    
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [chatViewController setFriendInfo:friendinfo];
    [chatViewController setChatType:chatTypeInvite];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

-(void)doGotoChat:(id)sender{
    NSLog(@"doGotoChat...");
    
    FriendInfo *friendinfo = [[FriendInfo alloc]init];
    friendinfo.fromMemberID = [_runner.userid longLongValue];
    
    ChatViewController *chatViewController = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    [chatViewController setFriendInfo:friendinfo];
    [chatViewController setChatType:chatTypeDefault];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

-(IBAction)doJiFen:(id)sender{
    
    NSLog(@"doJiFen...");
    
}

-(IBAction)doDuoBao:(id)sender{
    
    NSLog(@"doDuoBao...");
    
    TaskViewController *taskViewController = [[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil];
    [self.navigationController pushViewController:taskViewController animated:YES];
    
}

-(IBAction)doDuiHuan:(id)sender{
    
    NSLog(@"doDuiHuan...");
    
}

-(IBAction)doSina:(id)sender{
    
    NSLog(@"doSina...");
    
}

-(IBAction)doTel:(id)sender{
    
    NSLog(@"doTel...");
    
}

-(IBAction)doSelectHeadImg:(id)sender
{
    NSLog(@"doSelectHeadImg...");
    UIImagePickerController *pc = [[UIImagePickerController alloc]init];
    
    pc.delegate = self;
    
    pc.allowsEditing = NO;
    
    //pc.allowsImageEditing = NO;
    
    pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:pc animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    UIImage *imageNew = [UIImage createRoundedRectImage:image size:CGSizeMake(100, 100) radius:50];
    [self.btnHeadImg setImage:imageNew forState:UIControlStateNormal];
    
    [picker dismissModalViewControllerAnimated:YES];
    changeHeadImg = YES;
}

//-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
//}

#pragma textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    _tempScroll.frame = CGRectMake(0, 0, 320, height - 210);
    
    if (textField == _tallField || textField == _weightField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 200, 320, height - 210) animated:YES];
    } else if (textField == _areaField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 230, 320, height - 210) animated:YES];
    } else if (textField == _addressField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 260, 320, height - 210) animated:YES];
    } else if (textField == _telField) {
        [_tempScroll scrollRectToVisible:CGRectMake(0, 290, 320, height - 210) animated:YES];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    _tempScroll.frame = CGRectMake(0, 0, 320, height);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _tallField) {
        [_weightField becomeFirstResponder];
    } else if (textField == _weightField) {
        [_areaField becomeFirstResponder];
    } else if (textField == _areaField) {
        [_addressField becomeFirstResponder];
    } else if (textField == _addressField) {
        [_telField becomeFirstResponder];
    } else {
        
        float height = [UIScreen mainScreen].bounds.size.height - 20;
        _tempScroll.frame = CGRectMake(0, 0, 320, height);
        
        [textField resignFirstResponder];
        
    }
    
    return YES;
}

-(IBAction)resiginTextField:(id)sender{
    
    float height = [UIScreen mainScreen].bounds.size.height - 20;
    _tempScroll.frame = CGRectMake(0, 0, 320, height);
    
    [_tallField resignFirstResponder];
    [_weightField resignFirstResponder];
    [_areaField resignFirstResponder];
    [_addressField resignFirstResponder];
    [_telField resignFirstResponder];
    
}

- (void)viewDidUnload {
    [self setBtnHeadImg:nil];
    [super viewDidUnload];
}
@end
