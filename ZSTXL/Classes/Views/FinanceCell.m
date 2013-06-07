//
//  FinanceCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-7.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "FinanceCell.h"

@implementation FinanceCell

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

- (void)setFrame:(CGRect)frame {
    CGFloat inset = 8.f;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    
    [super setFrame:frame];
}

- (void)dealloc {
    [_nameLabel release];
    [_contentLabel release];
    [super dealloc];
}
@end
