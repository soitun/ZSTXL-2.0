//
//  UIPopoverListView.h
//  UIPopoverListViewDemo
//
//  Created by su xinde on 13-3-13.
//  Copyright (c) 2013年 su xinde. All rights reserved.
//

@class UIPopoverListView;

@protocol UIPopoverListViewDataSource <NSObject>
@required

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath;

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section;

@end

@protocol UIPopoverListViewDelegate <NSObject>
@optional

- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath;

- (void)popoverListViewCancel:(UIPopoverListView *)popoverListView;

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)popoverListconfirmSelect:(NSMutableArray *)array;
- (void)popoverListcancelSelect:(NSMutableArray *)array;

@end


@interface UIPopoverListView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_listView;
    UILabel     *_titleView;
    UIControl   *_overlayView;
    
    id<UIPopoverListViewDataSource> _datasource;
    id<UIPopoverListViewDelegate>   _delegate;
    
}

@property (nonatomic, assign) id<UIPopoverListViewDataSource> datasource;
@property (nonatomic, assign) id<UIPopoverListViewDelegate>   delegate;

@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIButton *confirmButton;
@property (nonatomic, retain) UITableView *listView;
@property (nonatomic, retain) NSMutableArray *selectArray;

- (void)setTitle:(NSString *)title;

- (void)show;
- (void)dismiss;

@end
