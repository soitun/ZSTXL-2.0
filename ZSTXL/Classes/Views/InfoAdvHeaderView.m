//
//  InfoAdvHeaderView.m
//  ZXCXBlyt
//
//  Created by zly on 12-4-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "InfoAdvHeaderView.h"

@implementation InfoAdvHeaderView

@synthesize mScrollView;
@synthesize labAdvTitle;
@synthesize advImageArray;
@synthesize mPageControl;
@synthesize advDatasourceArray;
@synthesize delegate;
@synthesize timer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    self.mScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageByName:@"default_bg_info"]];
    self.mScrollView.delegate = self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    NSInteger pageindex = point.x/320;
    self.mPageControl.currentPage = pageindex;
    
    //update adv title
    @try {
        NSDictionary *dict = [self.advDatasourceArray objectAtIndex:pageindex];
        NSString *title = [dict objForKey:@"informationtitle"];
        self.labAdvTitle.text = title;
    }
    @catch (NSException *exception) {
        NSLog(@"exception : %@", exception);
    }
}

- (void)updateAdvData:(NSArray *)array {
    if (self.advDatasourceArray == nil) {
        self.advDatasourceArray = [NSMutableArray array];
    } else {
        [self.advDatasourceArray removeAllObjects];
    }
    [self.advDatasourceArray addObjectsFromArray:array];
    
    for (EGOImageButton *buttonView in [mScrollView subviews]) {
        if ([buttonView isKindOfClass:[EGOImageButton class]]) {
            [buttonView cancelImageLoad];
            [buttonView removeFromSuperview];
        }
    }

    self.mPageControl.numberOfPages = [array count];
    mScrollView.contentSize = CGSizeMake([array count]*320, mScrollView.frame.size.height);

    for (int i = 0; i < [array count]; i++) {
        EGOImageButton *advImageView = [[[EGOImageButton alloc] initWithPlaceholderImage:nil] autorelease];
        advImageView.frame = CGRectMake(i*320, 0, 320, mScrollView.frame.size.height);
        advImageView.tag = i;
        [mScrollView addSubview:advImageView];
        
        NSDictionary *dict = [array objectAtIndex:i];
        NSString *url = [dict objectForKey:@"toppictureurl"];
        advImageView.imageURL = [url isValid] ? [NSURL URLWithString:url] : nil;
        if ([url isValid]) {
            [advImageView addTarget:self action:@selector(clickAdv:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    if ([delegate respondsToSelector:@selector(infoAdvDidUpdateWithArray:)]) {
        [delegate infoAdvDidUpdateWithArray:array];
    }
    
    [self initTimers];
}


- (void)initTimers {
    if (self.timer && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(switchAction) userInfo:nil repeats:YES];
}

- (void)switchAction {
    if (mScrollView.isDragging) {
        return;
    }
    
    if (mPageControl.currentPage < [advDatasourceArray count] - 1) {
        mPageControl.currentPage++;
    } else {
        mPageControl.currentPage = 0;
    }
    
    [mScrollView setContentOffset:CGPointMake(mPageControl.currentPage*320, 0) animated:YES];
}


- (void)clickAdv:(EGOImageButton *)sender {
    NSInteger index = sender.tag;
    NSDictionary *dict = [self.advDatasourceArray objectAtIndex:index];
    if ([delegate respondsToSelector:@selector(clickedInfoAdvDict:atIndex:)]) {
        [delegate performSelector:@selector(clickedInfoAdvDict:atIndex:) withObject:dict withObject:[NSNumber numberWithInt:index]];
    }
}

- (void)stopAnimate {
    if ([timer isValid]) {
        [timer invalidate];
    }
    self.timer = nil;
}

- (void)dealloc {

    if ([timer isValid]) {
        [timer invalidate];
    }
    self.timer = nil;
    [advDatasourceArray release];
    [advImageArray release];
    [mScrollView release];
    [labAdvTitle release];
    [mPageControl release];

    [super dealloc];
}
@end
