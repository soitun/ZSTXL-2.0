//
//  TheNewMessageCell.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-21.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheNewMessageCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *avatar;
@property (retain, nonatomic) IBOutlet UIImageView *chatIcon;
@property (retain, nonatomic) IBOutlet UIImageView *mailIcon;
@property (retain, nonatomic) IBOutlet UIImageView *messageIcon;

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;

@end
