//
//  ContactCell.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-9.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Contact;

@protocol ContactCellDelegate <NSObject>

- (void)contactCellTapAvatarOfContact:(Contact *)contact;

@end

@interface ContactCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *headIcon;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *xun_VImage;
@property (retain, nonatomic) IBOutlet UILabel *ZDLabel;
@property (retain, nonatomic) Contact *contact;
@property (assign, nonatomic) id<ContactCellDelegate> delegate;

@end
