//
//  ContactView.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-3.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PopContactViewDelegate <NSObject>

- (void)popContactViewTel;
- (void)popContactViewChat;

@end

@interface PopContactView : UIView
@property (retain, nonatomic) IBOutlet UIImageView *avatar;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *useridLabel;
@property (retain, nonatomic) IBOutlet UIImageView *xunImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunVImage;
@property (retain, nonatomic) IBOutlet UIImageView *xunBImage;
- (IBAction)telAction:(UIButton *)sender;
- (IBAction)chatAction:(UIButton *)sender;

@property (assign, nonatomic) id<PopContactViewDelegate> delegate;

@end
