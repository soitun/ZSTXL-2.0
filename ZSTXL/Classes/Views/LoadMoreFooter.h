//
//  LoadMoreFooter.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-30.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoadMoreFooter;

@protocol LoadMoreFooterDelegate <NSObject>

@optional
- (void)LoadMoreFooterTap:(LoadMoreFooter *)footer;

@end


@interface LoadMoreFooter : UIView
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, assign) id<LoadMoreFooterDelegate> delegate;

@end
