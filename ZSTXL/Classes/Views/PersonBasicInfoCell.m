//
//  PersonBasicInfoCell.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-27.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "PersonBasicInfoCell.h"

@implementation PersonBasicInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [self.maleButton addTarget:self action:@selector(chooseMale) forControlEvents:UIControlEventTouchUpInside];
    
    [self.femaleButton addTarget:self action:@selector(chooseFemale) forControlEvents:UIControlEventTouchUpInside];
}

- (void)chooseMale
{
    DLog(@"choosemale");
    if ([self.delegate respondsToSelector:@selector(chooseMale:)]) {
        [self.delegate performSelector:@selector(chooseMale:) withObject:self];
    }
}

- (void)chooseFemale
{
    if ([self.delegate respondsToSelector:@selector(chooseFemale:)]) {
        [self.delegate performSelector:@selector(chooseFemale:) withObject:self];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setFrame:(CGRect)frame {
    CGFloat inset = 8.f;
    frame.origin.x += inset;
    frame.size.width -= 2 * inset;
    
    [super setFrame:frame];
}

- (void)dealloc {
    [_titleLabel release];
    [_detailLabel release];
    [_maleButton release];
    [_femaleButton release];
    [super dealloc];
}
@end
