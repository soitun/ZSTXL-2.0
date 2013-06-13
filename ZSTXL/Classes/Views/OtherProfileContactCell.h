//
//  OtherProfileContactCell.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-13.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OtherProfileContactCellDelegate <NSObject>

- (void)OtherProfileTel;
- (void)OtherProfileMessage;
- (void)OtherProfileMail;
- (void)OtherProfileChat;


@end

@interface OtherProfileContactCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIButton *telButton;
@property (retain, nonatomic) IBOutlet UIButton *messageButton;
@property (retain, nonatomic) IBOutlet UIButton *mailButton;
@property (retain, nonatomic) IBOutlet UIButton *chatButton;

@property (nonatomic, assign) id<OtherProfileContactCellDelegate> delegate;

@end
