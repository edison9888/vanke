//
//  NearViewController.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"
#import "BMapKit.h"

#import "BaseViewController.h"

@interface NearViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, BMKMapViewDelegate>

@property (nonatomic, retain) IBOutlet BMKMapView *mapView;

@property (nonatomic, retain) PCustomNavigationBarView *navView;

@property (nonatomic, retain) IBOutlet UIButton *btnNearFriend;
@property (nonatomic, retain) IBOutlet UIImageView *nearTipImageView;
@property (nonatomic, retain) IBOutlet UIButton *btnCommunityFriend;
@property (nonatomic, retain) IBOutlet UIImageView *communityTipImageView;
@property (nonatomic, retain) IBOutlet UITableView *friendTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, assign) BOOL isShowNearFriend;
@property (nonatomic, retain) NSMutableArray *nearfriendlist;
@property (nonatomic, retain) NSMutableArray *communitylist;

@property (nonatomic, retain) NSString *currentLocation;

-(void)doBack;
-(void)initData;

-(void)getLbsList;
-(void)getLbsCommunityList;

-(IBAction)doNearFriend:(id)sender;
-(IBAction)doCommunityFriend:(id)sender;

@end
