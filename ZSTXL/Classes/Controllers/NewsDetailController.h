//
//  NewsDetailController.h
//  ZXCXBlyt
//
//  Created by zly on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCoreTextView.h"
#import "EGOImageLoader.h"
#import "OHAttributedLabel.h"
#import "NewsToolBar.h"
@class WebViewManager;
@protocol NewsDetailDelegate;
@interface NewsDetailController : UIViewController<UIScrollViewDelegate, FTCoreTextViewDelegate, EGOImageViewDelegate, OHAttributedLabelDelegate, NewsToolBarDelegate> {
    NSString *newsId;
    NSString *createrId;
    BOOL isNewsCollect;
    NSString *newsContent;
    NSArray *contentArray;
    int index;
}

@property (nonatomic, assign) BOOL isModelView;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) FTCoreTextView *coreTextView;
@property (copy, nonatomic)   NSString *newsId;
@property (copy, nonatomic)   NSString *createrId;
@property (copy, nonatomic)   NSString *newsContent;
@property (retain, nonatomic) IBOutlet UIButton *btnClickReload;
@property (nonatomic, retain) NSArray *contentArray;
@property (nonatomic, assign) id<NewsDetailDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *webViewContents;
@property (nonatomic, retain) WebViewManager *webViewManager;
@property (nonatomic, retain) NewsToolBar *newsToolBar;
@property (nonatomic, retain) NSArray *newsArray;
@property (nonatomic, assign) NSInteger newsIndex;
@property (nonatomic, retain) EGOImageView *imageView;


@end

@protocol NewsDetailDelegate <NSObject>
@optional
- (void)newsDidReviewed;
@end
