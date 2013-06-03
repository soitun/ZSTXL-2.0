//
//  ZSInfoContactView.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZSInfoContactViewDelegate <NSObject>

- (void)zsInfoContactViewTel;
- (void)zsInfoContactViewChat;

@end

@interface ZSInfoContactView : UIView

- (IBAction)tel:(UIButton *)sender;
- (IBAction)chat:(UIButton *)sender;

@property (assign, nonatomic) id<ZSInfoContactViewDelegate> delegate;

@end
