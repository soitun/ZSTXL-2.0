//
//  InformationCell.h
//  ZXCXBlyt
//
//  Created by zly on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationCell : UITableViewCell {
    UILabel *labTip;
    UILabel *labSubTitle;
    UILabel *labTitle;
    UIImageView *avatar;
}

@property (retain, nonatomic) IBOutlet UILabel *labSubTitle;
@property (retain, nonatomic) IBOutlet UILabel *labTitle;
@property (retain, nonatomic) IBOutlet UIImageView *avatar;
@property (assign, nonatomic) BOOL isSpecail;
@end
