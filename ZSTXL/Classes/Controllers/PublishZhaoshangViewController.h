//
//  PublishZhaoshangViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublishBaseViewController.h"
#import "SelectCityViewController.h"

@interface PublishZhaoshangViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, PublishBaseViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, SelectCityViewControllerDelegate>

@property (retain, nonatomic) IBOutlet UILabel *drugNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *drugNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *producerLabel;
@property (retain, nonatomic) IBOutlet UIImageView *drugImage;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, retain) NSArray *titleArray;
@property (nonatomic, retain) NSArray *selectorArray;



//    添加招商信息	/addInvestment.json		image	File	图片	durgid	long	药品ID	productname	String	商品名	proviceid	String	省ID	cityid	String	市ID	countyid	String	县ID（删除）	direction	String	方向	quale	String	招商性质	superiority	String	产品优势	duration	long	时长	userid	long	用户宝通号

@property (nonatomic, copy) NSString *drugId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *provinceId;
@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *direction;
@property (nonatomic, copy) NSString *quale;    //招商性质
@property (nonatomic, copy) NSString *superiority; //产品优势
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *userId;


@end
