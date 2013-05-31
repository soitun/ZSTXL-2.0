//
//  ConfirmFooterView.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ConfirmFooterViewDelegate <NSObject>

- (void)confirmFooterViewLeftAction;
- (void)confirmFooterViewRightAction;

@end

@interface ConfirmFooterView : UIView

@property (nonatomic, copy) NSString *leftButtonTitle;
@property (nonatomic, copy) NSString *rightButtonTitle;
@property (nonatomic, copy) id<ConfirmFooterViewDelegate> delegate;

- (IBAction)leftAction:(UIButton *)sender;
- (IBAction)rightAction:(UIButton *)sender;


@end
