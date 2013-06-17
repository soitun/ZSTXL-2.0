//
//  MailAddFriendViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-17.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@protocol MailAddFriendViewControllerDelegate  <NSObject>

- (void)mailAddFriend:(Contact *)contact;

@end

@interface MailAddFriendViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSMutableArray *dataSourceArray;
@property (retain, nonatomic) Contact *contact;

@property (assign, nonatomic) id<MailAddFriendViewControllerDelegate> delegate;

@end
