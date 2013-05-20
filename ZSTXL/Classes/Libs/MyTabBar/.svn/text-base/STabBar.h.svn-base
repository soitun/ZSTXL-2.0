//
//  STabBar.h
//  TestTabBar
//
//  Created by fang yuxi on 11-12-23.
//  Copyright (c) 2011年 Sohu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STabBarItem.h"

@class STabBar;

@protocol STabBarDelegate <NSObject>

- (void) sTabBarItemSelectedAtIndex:(NSInteger)index;

@end

@interface STabBar : UIView<STabBarItemDelegate,UITabBarControllerDelegate>
{
    NSMutableArray *_items;
    id<STabBarDelegate> _delegate;
}

@property (nonatomic, retain) NSMutableArray *items;//之前放在.m里。

@property (nonatomic, assign) UIImage* backgoundImage;
@property (nonatomic, assign) id<STabBarDelegate> delegate;
@property (nonatomic, retain) UIImageView *selectBGImgV;//**liu**

@end

@interface STabBar(PublicMethod)

- (void) addItem:(STabBarItem*)item;
- (void) setSelectedItemAtIndex:(NSInteger)index;
- (void) setSelectedItem:(STabBarItem *)item;

@end


