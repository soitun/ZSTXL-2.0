//
//  STabBarItem.h
//  TestTabBar
//
//  Created by fang yuxi on 11-12-23.
//  Copyright (c) 2011年 Sohu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBadge.h"

@class STabBarItem;

@protocol STabBarItemDelegate <NSObject>

@optional

- (void) STabBarItemSeletedAtIndex:(NSInteger)index item:(STabBarItem*)item;

@end

@interface STabBarItem : UIButton
{
    id<STabBarItemDelegate> _delegate;
    
    NSInteger _itemIndex;
    TBadge   *_badge;
    NSString *_badgeValue;
    UIImage  *_normalImage;
    UIImage  *_selectedImage;
}

@property (nonatomic, assign) id<STabBarItemDelegate> delegate;
@property (nonatomic, assign) NSInteger itemIndex;
@property (nonatomic, retain) UIImage *normalImage;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, copy)   NSString *badgeValue;

+ (CGRect)GetAptlySize: (CGSize)size frame:(CGRect)rect;
- (void) setBadgeValue:(NSString *)badgeValue;

@end
