//
//  DeleteChatView.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-8.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DeleteChatViewDelegate <NSObject>

- (void)deleteChat;
- (void)deleteChatCancel;

@end

@interface DeleteChatView : UIView

- (IBAction)deleteAction:(UIButton *)sender;
- (IBAction)cancelAction:(UIButton *)sender;

@property (nonatomic, retain) UIControl *bgControl;
@property (nonatomic, assign) id<DeleteChatViewDelegate> delegate;

- (void)dismiss;
- (void)showInView:(UIView *)view;

@end
