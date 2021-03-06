//
//  InfoAdvHeaderView.h
//  ZXCXBlyt
//
//  Created by zly on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoView.h"

@protocol InfoAdvDelegate;

@interface InfoAdvHeaderView : UIView<UIScrollViewDelegate> {
    UIScrollView *mScrollView;
    UILabel *labAdvTitle;
    NSMutableArray *advImageArray;
    NSMutableArray *advDatasourceArray;
    id<InfoAdvDelegate> delegate;
}

@property (retain, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (retain, nonatomic) IBOutlet UILabel *labAdvTitle;
@property (retain, nonatomic) NSMutableArray *advImageArray;
@property (retain, nonatomic) IBOutlet UIPageControl *mPageControl;
@property (retain, nonatomic) NSMutableArray *advDatasourceArray;
@property (assign, nonatomic) id<InfoAdvDelegate> delegate;
@property (nonatomic, retain) NSTimer *timer;

- (void)updateAdvData:(NSArray *)array;
- (void)stopAnimate;
@end

@protocol InfoAdvDelegate <NSObject>
@optional
- (void)clickedInfoAdvDict:(NSDictionary *)advDict atIndex:(NSNumber *)index;
- (void)infoAdvDidUpdateWithArray:(NSArray *)array;

@end