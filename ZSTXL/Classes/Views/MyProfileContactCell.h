//
//  MyProfileContactCell.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-12.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

@protocol MyProfileContactCellDelegate <NSObject>

- (void)myProfileMail;
- (void)myProfileMessage;
- (void)myProfileChat;

@end

@interface MyProfileContactCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *messageButton;
@property (retain, nonatomic) IBOutlet UIButton *mailButton;
@property (retain, nonatomic) IBOutlet UIButton *chatButton;

@property (retain, nonatomic) CustomBadge *messageBadge;
@property (retain, nonatomic) CustomBadge *mailBadge;
@property (retain, nonatomic) CustomBadge *chatBadge;

@property (copy, nonatomic) NSString *messageBadgeValue;
@property (copy, nonatomic) NSString *mailBadgeValue;
@property (copy, nonatomic) NSString *chatBadgeValue;

@property (nonatomic, assign) id<MyProfileContactCellDelegate> delegate;

@end
