//
//  DeleteChatView.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-8.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "DeleteChatView.h"

@implementation DeleteChatView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"DeleteChatView" owner:nil options:nil] lastObject];
    if (self) {
        self.bgControl = [[[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)] autorelease];
        self.bgControl.backgroundColor = RGBACOLOR(0, 0, 0, 0.6);
        [self.bgControl addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        self.frame = CGRectMake(34, SCREEN_HEIGHT-203-80, 258, 203);
        
        [self.bgControl addSubview:self];
    }
    return self;
}

- (void)dismiss
{
    if (self.bgControl.superview) {
        [self.bgControl removeFromSuperview];
        self.bgControl = nil;
    }
}

- (void)showInView:(UIView *)view
{
    [view addSubview:self.bgControl];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)deleteAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(deleteChat));
    [self dismiss];
}

- (IBAction)cancelAction:(UIButton *)sender
{
    PERFORM_SELECTOR(self.delegate, @selector(deleteChatCancel));
    [self dismiss];
}
@end
