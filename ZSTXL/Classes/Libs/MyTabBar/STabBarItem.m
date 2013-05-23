//
//  STabBarItem.m
//  TestTabBar
//
//  Created by fang yuxi on 11-12-23.
//  Copyright (c) 2011年 Sohu. All rights reserved.
//

#import "STabBarItem.h"

@interface STabBarItem(PrivateMethod)

- (void) notifyDelegate:(id)sender;
@end

@implementation STabBarItem

@synthesize delegate = _delegate;
@synthesize itemIndex = _itemIndex;
@synthesize normalImage = _normalImage;
@synthesize selectedImage = _selectedImage;
@synthesize badgeValue = _badgeValue;

#pragma mark init & dealloc
#pragma ---

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
//        self.showsTouchWhenHighlighted = YES;
        TBadge *_bv = [[TBadge alloc] newBadge];
		_badge = _bv;
        _badge.center = CGPointMake(self.frame.origin.x + 52, self.frame.origin.y + 12);//80->52
        [self addSubview:_badge];
		[_bv release];
        [self addTarget:self action:@selector(notifyDelegate:) forControlEvents:UIControlEventTouchDown];//TouchUpInside
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleEdgeInsets = UIEdgeInsetsMake(40, 0, 5, 0);
        
    }
    return self;
}

- (void) dealloc
{
    [_badge release];
    [_badgeValue release];
    
    self.normalImage = nil;
    self.selectedImage = nil;
    
    [super dealloc];
}

#pragma mark private method
#pragma ---

- (void) notifyDelegate:(id)sender
{
    if ([(NSObject*)self.delegate respondsToSelector:@selector(STabBarItemSeletedAtIndex:item:)])
    {
        [self.delegate STabBarItemSeletedAtIndex:self.itemIndex item:self];
    }
}


//Item里的Image的位置。rect是铺满。rcImage是经过调整之后的
- (void) drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIImage* tmpImage = nil;
    if (self.selected)
    {
        tmpImage = self.selectedImage;
    }
    else
    {
        tmpImage = self.normalImage;
    }
    CGRect rcImage = [STabBarItem GetAptlySize:tmpImage.size frame:rect];
    rcImage.origin.y = + 2;
    [tmpImage drawInRect:CGRectMake(29, 8, 21, 21)];
}

#pragma mark public method
#pragma ---

- (void) setBadgeValue:(NSString *)badgeValue
{
    if (badgeValue == _badgeValue)
    {
        return;
    }
    [_badgeValue release];
    _badgeValue = nil;
    _badgeValue = [badgeValue retain];
    _badge.value = _badgeValue;
}

+ (CGRect)GetAptlySize: (CGSize)size frame:(CGRect)rect
{
	CGRect mySize;
	if ( size.width < rect.size.width && size.height < rect.size.height )
	{
		mySize = CGRectMake(rect.origin.x + (rect.size.width - size.width)/2,
							rect.origin.y + (rect.size.height - size.height)/2, 
							size.width,
							size.height);
		
		return mySize;
	}
	
	float fOrg = rect.size.width / rect.size.height;
	float fTar = size.width / size.height;
	
	if (fTar > fOrg)
	{
		mySize = CGRectMake(rect.origin.x,rect.origin.y, rect.size.width, size.height*rect.size.width/size.width);
		mySize.origin.y += (rect.size.height - mySize.size.height)/2;
	}
	else if ( fTar < fOrg )
	{
		mySize = CGRectMake(rect.origin.x,rect.origin.y, size.width*rect.size.height/size.height, rect.size.height);
		mySize.origin.x += (rect.size.width - mySize.size.width)/2;
	}
	else
	{
		mySize = rect;
	}
	
	return mySize;	
}

@end




