//
//  MailSelectorView.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MailSelectorViewDelegate <NSObject>

- (void)MailSelectorChooseIndexPath:(NSIndexPath *)indexPath;

@end

@interface MailSelectorView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) id<MailSelectorViewDelegate> delegate;
@property (nonatomic, retain) NSArray *titleArray;

@end
