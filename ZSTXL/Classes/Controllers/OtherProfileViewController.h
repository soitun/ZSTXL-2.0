//
//  OtherProfileViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-13.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherProfileContactCell.h"
#import "OtherProfileHeader.h"
#import "Contact.h"

@protocol OtherProfileDelegate <NSObject>

- (void)otherProfileFriendRefresh;

@end

@interface OtherProfileViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, OtherProfileContactCellDelegate, OtherProfileHeaderDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) OtherProfileHeader *tableHeader;
@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, retain) NSMutableArray *contentArray;
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, retain) Contact *contact;
@property (nonatomic, copy) NSString *residentArea;
@property (nonatomic, copy) NSString *pharmacologyCategory;
@property (nonatomic, retain) UIButton *addFriendButton;
@property (nonatomic, assign) id<OtherProfileDelegate> delegate;

@end
