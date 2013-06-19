//
//  MyTalkCell.m
//  ZXCXBlyt
//
//  Created by zly on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MyTalkCell.h"

@implementation MyTalkCell
@synthesize labTime;
@synthesize labContent;
@synthesize bgImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)awakeFromNib {
    self.bgImageView.image = [UIImage stretchableImage:@"d_pop_right" leftCap:20 topCap:20];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.labContent.frame = CGRectMake(90, 22, 190, 0);
    [self.labContent sizeToFit];
    CGSize contentSize = [labContent.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(190, CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
    
    CGFloat imgWidth = MAX(48, contentSize.width+30);
    
    self.bgImageView.frame = CGRectMake(300 - imgWidth, bgImageView.frame.origin.y, imgWidth, contentSize.height + 20);
    self.labContent.center = CGPointMake(self.bgImageView.center.x-5, self.bgImageView.center.y-1);
}

+ (CGFloat)heightForCellWithContent:(NSString *)content {
    CGFloat offset = 15.0f;
    CGSize contentSize = [content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(200, CGFLOAT_MAX) lineBreakMode:UILineBreakModeCharacterWrap];
    return contentSize.height + offset + 40;
}

- (void)dealloc {
    [labTime release];
    [labContent release];
    [bgImageView release];
    [super dealloc];
}
@end
