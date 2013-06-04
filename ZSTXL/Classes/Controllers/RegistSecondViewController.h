//
//  RegistSecondViewController.h
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistSecondViewController : UIViewController

@property (copy, nonatomic) NSString *userid;
@property (retain, nonatomic) IBOutlet UILabel *useridLabel;
- (IBAction)confirm:(UIButton *)sender;

@end
