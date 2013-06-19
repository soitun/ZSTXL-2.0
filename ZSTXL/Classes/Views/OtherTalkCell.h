//
//  OtherTalkCell.h
//  ZXCXBlyt
//
//  Created by zly on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherTalkCell : UITableViewCell


@property (retain, nonatomic) IBOutlet UIImageView *avatar;
@property (retain, nonatomic) IBOutlet UILabel *labTime;
@property (retain, nonatomic) IBOutlet UILabel *labContent;
@property (retain, nonatomic) IBOutlet UIImageView *bgImageView;

+ (CGFloat)heightForCellWithContent:(NSString *)content;

@end
