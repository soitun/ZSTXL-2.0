//
//  TitleView.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "TitleView.h"

@implementation TitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGSize titleSize = [self.title sizeWithFont:[UIFont boldSystemFontOfSize:20] constrainedToSize:CGSizeMake(200, 44)];
    
    DLog(@"center %@", NSStringFromCGPoint(self.center));
    
    self.titleLabel.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
    self.titleLabel.center = CGPointMake(self.frame.size.width/2-4, self.center.y);
    self.titleLabel.frame = CGRectIntegral(self.titleLabel.frame);
    self.titleLabel.text = self.title;
    
    CGFloat x = self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width+2;
    self.Angle.frame = CGRectMake(x, 26, 9, 6);
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMe:)] autorelease];
    [self addGestureRecognizer:tap];
}

- (void)tapMe:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(titleViewTap)]) {
        [self.delegate performSelector:@selector(titleViewTap)];
    }
}

- (void)dealloc {
    [_titleLabel release];
    [_Angle release];
    [super dealloc];
}
@end
