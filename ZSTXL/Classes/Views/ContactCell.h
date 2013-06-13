//
//  ContactCell.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@protocol ContactCellDelegate <NSObject>

- (void)contactCellTapAvatarOfContact:(Contact *)contact;

@optional
- (void)contactCellAddFriend:(Contact *)contact atIndexPath:(NSIndexPath *)indexPath;

@end

@interface ContactCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *cityLabel;
@property (retain, nonatomic) IBOutlet UIImageView *headIcon;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *ZDLabel;
@property (retain, nonatomic) IBOutlet UILabel *preferLabel;
@property (retain, nonatomic) Contact *contact;
@property (assign, nonatomic) id<ContactCellDelegate> delegate;

@property (retain, nonatomic) IBOutlet UIButton *addFriendButton;
@property (retain, nonatomic) IBOutlet UILabel *haveAddLabel;
@property (retain, nonatomic) NSIndexPath *indexPath;

- (void)refresh;

@end
