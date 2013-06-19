//
//  FriendViewController.h
//  vanke
//
//  Created by pig on 13-6-12.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCustomNavigationBarView.h"

@interface FriendViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) PCustomNavigationBarView *navView;
@property (nonatomic, retain) IBOutlet UITableView *friendTableView;

@property (nonatomic, retain) NSMutableArray *friendList;

-(void)doBack;
-(void)initData;
-(void)doGotoChat:(id)sender;

@end