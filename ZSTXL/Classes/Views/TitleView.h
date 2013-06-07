//
//  TitleView.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TitleViewDelegate <NSObject>

@optional
- (void)titleViewTap;

@end

@interface TitleView : UIView

@property (nonatomic, copy) NSString *title;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *Angle;
@property (nonatomic, assign) id<TitleViewDelegate> delegate;

@end
