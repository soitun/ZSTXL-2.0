//
//  PublishView.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublishViewDelegate <NSObject>

- (void)publishViewZhaoshang;
- (void)publishViewDaili;
- (void)publishViewCancel;

@end

@interface PublishView : UIView
- (IBAction)PublishZhaoshang:(UIButton *)sender;
- (IBAction)PublishDaili:(UIButton *)sender;
- (IBAction)PublishCancel:(UIButton *)sender;

@property (retain, nonatomic) id<PublishViewDelegate> delegate;

@end
