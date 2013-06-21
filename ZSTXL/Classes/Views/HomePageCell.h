//
//  HomePageCell.h
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-16.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;

@property (copy, nonatomic) NSString *badgeValue;
@property (retain, nonatomic) CustomBadge *theBadge;

@end
