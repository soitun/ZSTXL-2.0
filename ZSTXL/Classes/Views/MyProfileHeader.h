//
//  MyProfileHeader.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-12.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyProfileHeaderDelegate <NSObject>

- (void)myProfileAttent;
- (void)myProfileStar;
- (void)myProfileBlacklist;
- (void)myProfileModifyImage;

@end

@interface MyProfileHeader : UIView
@property (retain, nonatomic) IBOutlet UIImageView *headIcon;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *userIdLabel;
@property (retain, nonatomic) IBOutlet UILabel *telLabel;
@property (retain, nonatomic) IBOutlet UIImageView *gradeImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunVImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunBImage;

@property (retain, nonatomic) IBOutlet UIView *attentView;
@property (retain, nonatomic) IBOutlet UIView *starView;
@property (retain, nonatomic) IBOutlet UIView *blacklistView;
@property (retain, nonatomic) IBOutlet UILabel *attentNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *starNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *blacklistNumLabel;

@property (assign, nonatomic) id<MyProfileHeaderDelegate> delegate;

@end
