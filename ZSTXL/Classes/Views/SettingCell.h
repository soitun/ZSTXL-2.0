//
//  SettingCell.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SettingCell;

@protocol SettingCellDelegate <NSObject>

- (void)switchOnOff:(SettingCell *)cell;
- (void)select:(SettingCell *)cell;

@end

@interface SettingCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *selectImage;
@property (retain, nonatomic) IBOutlet UIImageView *switchImage;
@property (nonatomic, assign) id<SettingCellDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *onLabel;
@property (nonatomic, retain) IBOutlet UILabel *offLabel;

@end


