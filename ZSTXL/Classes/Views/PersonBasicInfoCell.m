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
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseMale)];
    [self.chooseMaleImage addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseFemale)];
    [self.chooseFemaleImage addGestureRecognizer:tap2];
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
    [_maleLabel release];
    [_femaleLabel release];
    [_chooseMaleImage release];
    [_chooseFemaleImage release];
    [super dealloc];
}
@end
