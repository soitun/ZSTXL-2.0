//
//  PublishZhaoshangViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishZhaoshangViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>

@property (retain, nonatomic) IBOutlet UILabel *drugNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *drugNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *producerLabel;
@property (retain, nonatomic) IBOutlet UIImageView *drugImage;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, retain) NSArray *selectorArray;


@end
