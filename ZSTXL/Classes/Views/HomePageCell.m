//
//  HomePageCell.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-16.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "HomePageCell.h"

@implementation HomePageCell

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

- (void)drawRect:(CGRect)rect
{
    CGRect nameLabFrame = self.nameLabel.frame;
    CGSize nameLabSize = [self.nameLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    nameLabFrame.size= nameLabSize;
    nameLabFrame.origin.y = (self.frame.size.height - nameLabSize.height)/2;
    self.nameLabel.frame = nameLabFrame;
    
    CGRect detailLabFrame = self.detailLabel.frame;
    detailLabFrame.origin.x = nameLabFrame.origin.x + nameLabSize.width + 5;
    CGSize detailLabSize = [self.detailLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:16] constrainedToSize:CGSizeMake(300-detailLabFrame.origin.x+5, 35)];
    detailLabFrame.size = detailLabSize;
    detailLabFrame.origin.y = (self.frame.size.height - detailLabSize.height)/2;
    self.detailLabel.frame = detailLabFrame;
}


- (void)setFrame:(CGRect)frame {
    CGFloat inset = 8.f;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    [super setFrame:frame];
}

- (void)dealloc {
    [_nameLabel release];
    [_separatorImage release];
    [_detailLabel release];
    [super dealloc];
}
@end
