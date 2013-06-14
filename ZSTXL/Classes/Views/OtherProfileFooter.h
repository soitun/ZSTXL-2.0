//
//  OtherProfileFooter.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-14.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OtherProfileFooterDelegate <NSObject>

- (void)otherProfileAddFriend;
- (void)otherProfileAddBlack;

@end

@interface OtherProfileFooter : UIView

@property (retain, nonatomic) IBOutlet UIButton *addFriendButton;
@property (retain, nonatomic) IBOutlet UIButton *addBlackButton;

@property (assign, nonatomic) id<OtherProfileFooterDelegate> delegate;

@end
