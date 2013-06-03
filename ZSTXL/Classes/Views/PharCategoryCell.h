//
//  PharCategoryCell.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PharCategoryCellDelegate <NSObject>

- (void)pharCategotyCellTap;

@end

@interface PharCategoryCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *pharImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;
@property (retain, nonatomic) IBOutlet UIImageView *theNewImage;
@property (retain, nonatomic) IBOutlet UIButton *bottomButton;

@property (assign, nonatomic) id<PharCategoryCellDelegate> delegate;

@end
