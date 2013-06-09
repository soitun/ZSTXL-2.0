//
//  NewsToolBar.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-8.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsToolBarDelegate <NSObject>

- (void)newsStar;
- (void)newsUp;
- (void)newsDown;
- (void)newsContact;

@end


@interface NewsToolBar : UIView


@property (retain, nonatomic) IBOutlet UIButton *newsStarButton;

- (IBAction)newUpAction:(UIButton *)sender;
- (IBAction)newDownAction:(UIButton *)sender;
- (IBAction)newsContactAction:(UIButton *)sender;

@property (nonatomic, assign) id<NewsToolBarDelegate> delegate;

@end
