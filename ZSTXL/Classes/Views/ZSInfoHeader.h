//
//  ZSInfoHeader.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZSInfoHeaderDelegate <NSObject>

- (void)zsInfoHeaderContactMe;
- (void)zsINfoHeaderContactStar;

@end

@interface ZSInfoHeader : UIView
@property (retain, nonatomic) IBOutlet UIImageView *avatar;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *useridLabel;
@property (retain, nonatomic) IBOutlet UIImageView *xunImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunVImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunBImage;
@property (retain, nonatomic) IBOutlet UIImageView *bgImage;
@property (retain, nonatomic) IBOutlet UIImageView *starImage;

@property (assign, nonatomic) id<ZSInfoHeaderDelegate> delegate;

- (IBAction)contactMe:(UIButton *)sender;

@end
