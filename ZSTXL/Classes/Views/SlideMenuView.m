//
//  SlideMenuView.m
//  BLSY
//
//  Created by zly on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SlideMenuView.h"

@implementation SlideMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithItemsArray:(NSArray *)array
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 34)];
    if (self) {
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 34)] autorelease];
        imageView.image = [UIImage imageByName:@"icon_slide_tool"];
        [self addSubview:imageView];
        UIImage *stretch = [UIImage stretchableImage:@"bg_slider" leftCap:35 topCap:0];
        self.bgSlideView = [[[UIImageView alloc] initWithImage:stretch] autorelease];
        [self addSubview:self.bgSlideView];
        
        self.buttonsArray = [NSMutableArray array];
        NSInteger arrayCount = [array count];
        for (int i = 0; i < arrayCount; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            button.adjustsImageWhenHighlighted = NO;
            button.showsTouchWhenHighlighted = YES;
            button.tag = i;
            [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:16]];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2, 0);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(buttonOnClick:) forControlEvents:UIControlEventTouchUpInside];
            CGFloat width = 320.0/arrayCount;
            button.frame = CGRectMake((int)(i*320.0/arrayCount), 0, (int)width+1, 34);
            [self addSubview:button];
            [self.buttonsArray addObject:button];
            if (i == 0) {
                self.bgSlideView.frame = CGRectMake(button.frame.origin.x, button.frame.size.height - 4, button.frame.size.width, 4) ;
            }
        }
        [self updateMenuButtonState];
    }
    return self;
}

- (void)updateMenuButtonState {
    //DO Nothing
}

@end
