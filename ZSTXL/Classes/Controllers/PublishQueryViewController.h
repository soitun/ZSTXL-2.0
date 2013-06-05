//
//  PublishQueryViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishQueryViewController : UIViewController <UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIButton *leftButton;
@property (retain, nonatomic) IBOutlet UIButton *rightButton;

@property (retain, nonatomic) IBOutlet UILabel *pharNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *producerLabel;
@property (retain, nonatomic) IBOutlet UILabel *drugFormLabel;
@property (retain, nonatomic) IBOutlet UILabel *specLabel;
@property (retain, nonatomic) IBOutlet UITextView *orientationTextView;

@property (retain, nonatomic) IBOutlet UITextField *drugNumTextField;
@property (retain, nonatomic) IBOutlet UIImageView *sepImage;

@property (copy, nonatomic) NSString *drugNum;
@property (copy, nonatomic) NSString *drugId;
@property (copy, nonatomic) NSString *productName;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) BOOL queryFinished;

@end
