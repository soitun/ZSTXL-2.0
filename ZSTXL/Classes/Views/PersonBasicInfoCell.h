//
//  PersonBasicInfoCell.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonBasicInfoCell;

@protocol PersonBasicInfoCellDelegate <NSObject>

- (void)chooseMale:(PersonBasicInfoCell *)cell;
- (void)chooseFemale:(PersonBasicInfoCell *)cell;

@end

@interface PersonBasicInfoCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;

@property (retain, nonatomic) IBOutlet UIImageView *chooseMaleImage;
@property (retain, nonatomic) IBOutlet UIImageView *chooseFemaleImage;

@property (retain, nonatomic) IBOutlet UILabel *maleLabel;
@property (retain, nonatomic) IBOutlet UILabel *femaleLabel;

@property (nonatomic, assign) id<PersonBasicInfoCellDelegate> delegate;

@end
