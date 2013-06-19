//
//  ChatCell.h
//  vanke
//
//  Created by pig on 13-6-13.
//  Copyright (c) 2013年 pig. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendInfo.h"
#import "ChatMessage.h"

@interface ChatCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UIImageView *leftHeadImageView;
@property (nonatomic, retain) IBOutlet UIImageView *rightHeadImageView;
@property (nonatomic, retain) IBOutlet UIImageView *textBgImageView;
@property (nonatomic, retain) IBOutlet UILabel *lblChatText;

@property (nonatomic, retain) ChatMessage *chatmessage;
@property (nonatomic, retain) FriendInfo *friendinfo;

-(void)updateView;

@end