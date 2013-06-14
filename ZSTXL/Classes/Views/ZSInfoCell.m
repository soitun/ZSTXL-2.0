//
//  ZSInfoCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ZSInfoCell.h"

@implementation ZSInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)layoutSubviews
{
    NSString *text = self.contentLabel.text;
    
    CGSize constraint = CGSizeMake(285.0f, 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    DLog(@"size %@", NSStringFromCGSize(size));
    CGFloat height = MAX(size.height, 21.0f);
    CGRect labFrame = self.contentLabel.frame;
    labFrame.size.height = height;
    self.contentLabel.frame = labFrame;
//    DLog(@"lab frame %@", NSStringFromCGRect(labFrame));
}

- (void)dealloc {
    [_nameLabel release];
    [_contentLabel release];
    [_separator release];
    [super dealloc];
}
@end
