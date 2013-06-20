//
//  ContactView.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@protocol PopContactViewDelegate <NSObject>

- (void)popContactViewTel:(NSString *)tel;
- (void)popContactViewChat:(Contact *)contact;
- (void)popContactViewTapAvatar:(Contact *)contact;

@end

@interface PopContactView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *avatar;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *useridLabel;
@property (retain, nonatomic) IBOutlet UIImageView *xunImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunVImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunBImage;
@property (retain, nonatomic) UIControl *bgControl;
@property (retain, nonatomic) Contact *contact;
@property (assign, nonatomic) id<PopContactViewDelegate> delegate;

- (IBAction)closeAction:(UIButton *)sender;
- (IBAction)telAction:(UIButton *)sender;
- (IBAction)chatAction:(UIButton *)sender;
- (id)initWithNib:(NSString *)nib;
- (void)showInView:(UIView *)view;
@end
