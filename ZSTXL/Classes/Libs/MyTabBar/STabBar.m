//
//  STabBar.m
//  TestTabBar
//
//  Created by fang yuxi on 11-12-23.
//  Copyright (c) 2011年 Sohu. All rights reserved.
//

#import "STabBar.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
@interface STabBar()



@end

@implementation STabBar

@synthesize backgoundImage;
@synthesize items = _items;
@synthesize delegate = _delegate;
@synthesize selectBGImgV;

#pragma mark init & dealloc
#pragma ---

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.items = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}

- (void) dealloc
{
    [selectBGImgV release];
    self.selectBGImgV = nil;
    self.items = nil;
    [super dealloc];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < _items.count; i ++) {
        STabBarItem *takeItem = [_items objectAtIndex:i];
        [takeItem setFrame:CGRectMake(320/_items.count*i, 5, 320/_items.count, 40)];
    }
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

#pragma mark public method
#pragma ---

- (void) setBackgoundImage:(UIImage *)thebackgoundImage
{
    backgoundImage = thebackgoundImage;
    self.layer.contents = (id)backgoundImage.CGImage;
}

- (void) addItem:(STabBarItem*)item
{
    [self.items addObject:item];
    [self addSubview:item];
    item.itemIndex = [self.items count] - 1;
    item.delegate = self;
    [self setNeedsLayout];
}

- (void) setItems:(NSMutableArray *)items
{
    if (items == _items)
    {
        return;
    }
    
    /** 先把以前的所有items去掉 **/
    for (STabBarItem* item in _items)
    {
        [item removeFromSuperview];
    }
    
    [_items release];
    _items = nil;
    _items = [items retain];
    
    NSInteger index = 0;
    
    /** 将新的加进来 **/
    for (STabBarItem* item in _items)
    {
        item.itemIndex = index;
        ++index;
        
        item.delegate = self;
        [self addSubview:item];
    }
    self.selectBGImgV = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
    [self addSubview:self.selectBGImgV];
    [self setNeedsLayout];
}

- (void) setSelectedItemAtIndex:(NSInteger)index
{
    [[self.items objectAtIndex:index] setSelected:YES];
    
    for (STabBarItem* theItem in self.items)
    {
        STabBarItem *item = [self.items objectAtIndex:index];
        if (item != theItem)
        {
            [theItem setSelected:NO];
        }
    }

}

- (void) setSelectedItem:(STabBarItem *)item
{
    [item setSelected:YES];
}

#pragma mark sTabBarItemDelegate
#pragma ---

- (void) STabBarItemSeletedAtIndex:(NSInteger)index item:(STabBarItem *)item
{
    /** 调用系统本身代理 **/

    if ([(NSObject*)self.delegate respondsToSelector:@selector(sTabBarItemSelectedAtIndex:)])
    {
        [self.delegate sTabBarItemSelectedAtIndex:index];
    }

}



@end






