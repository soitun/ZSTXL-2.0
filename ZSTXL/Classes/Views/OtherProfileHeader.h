//
//  OtherProfileHeader.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-13.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OtherProfileHeaderDelegate <NSObject>

- (void)otherProfileHeaderComment;

@end


@interface OtherProfileHeader : UIView

@property (retain, nonatomic) IBOutlet UIImageView *avatar;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *userIdLabel;
@property (retain, nonatomic) IBOutlet UIImageView *xunImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunVImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunBImage;

@property (assign, nonatomic) id<OtherProfileHeaderDelegate> delegate;

- (IBAction)commentAction:(UIButton *)sender;

@end
