//
//  ZhaoshangDailiViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-20.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhaoshangDailiViewController : UIViewController <UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *adScrollView;
@property (retain, nonatomic) IBOutlet UIScrollView *cateScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *adScrollPageControl;

@property (nonatomic, retain) NSMutableArray *cateNameArray;
@property (nonatomic, retain) NSMutableArray *cateImageArray;

@end
