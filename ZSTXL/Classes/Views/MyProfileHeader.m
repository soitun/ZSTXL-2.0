//
//  MyProfileHeader.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-12.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MyProfileHeader.h"

@implementation MyProfileHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.attentView.backgroundColor = bgGreyColor;
    self.starView.backgroundColor = bgGreyColor;
    self.blacklistView.backgroundColor = bgGreyColor;
    [Utility addRoundCornerToView:self.headIcon radius:5];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = bgGreyColor;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAttentView:)];
    [self.attentView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapStarView:)];
    [self.starView addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBlacklistView:)];
    [self.blacklistView addGestureRecognizer:tap3];
    
    self.headIcon.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadIcon:)];
    [self.headIcon addGestureRecognizer:tapImage];
    
}


- (void)dealloc {
    [_headIcon release];
    [_nameLabel release];
    [_userIdLabel release];
    [_telLabel release];
    [_gradeImage release];
    [_xunImage release];
    [_xunVImage release];
    [_xunBImage release];
    [_attentView release];
    [_starView release];
    [_blacklistView release];
    [_attentNumLabel release];
    [_starNumLabel release];
    [_blacklistNumLabel release];
    [super dealloc];
}

#pragma mark - tap

- (void)tapHeadIcon:(UITapGestureRecognizer *)tap
{
    PERFORM_SELECTOR(self.delegate, @selector(myProfileModifyImage));
}

- (void)tapAttentView:(UITapGestureRecognizer *)tap
{
    PERFORM_SELECTOR(self.delegate, @selector(myProfileAttent));
}

- (void)tapStarView:(UIGestureRecognizer *)tap
{
    PERFORM_SELECTOR(self.delegate, @selector(myProfileStar));
}

- (void)tapBlacklistView:(UITapGestureRecognizer *)tap
{
    PERFORM_SELECTOR(self.delegate, @selector(myProfileBlacklist));
}

@end
