//
//  InviteFriendViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-6-5.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface InviteFriendViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMessageComposeViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) NSMutableArray *datasourceArray;
@property (retain, nonatomic) NSMutableArray *selectArray;
@property (retain, nonatomic) NSMutableArray *sectionArray;
@property (retain, nonatomic) NSMutableDictionary *contactDict;


@end
