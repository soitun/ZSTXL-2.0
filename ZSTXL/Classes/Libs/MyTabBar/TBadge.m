//
//  TBadge.m
//  SohuWeibo
//
//  Created by fang yuxi on 10-12-30.
//  Copyright 2011 Sohu MTC. All rights reserved.
//

#import "TBadge.h"

@interface TBadge(Private)

- (void)initState;
- (CGPathRef)createBadgePathForTextSize:(CGSize)inSize;
- (BOOL)needShowBadge;

@end

@implementation TBadge
@synthesize value=_value;
@synthesize shadow=_shadow;
@synthesize shine=_shine;
@synthesize font=_font;
@synthesize fillColor=_fillColor;
@synthesize strokeColor=_strokeColor;
@synthesize textColor=_textColor;
@synthesize alignment=_alignment;
@dynamic badgeSize;
@synthesize pad=_pad;

#define BadgeWidth 55
#define BadgeHeight 40

////////////-----刘晓龙改的----------///
//#define BadgeWidth 80
//#define BadgeHeight 44
///////////////-------------------////


#pragma mark -
#pragma mark init & dealloc
//	支持显示最大值为“9999＋”
- (id)newBadge
{
	if (self = [self initWithFrame:CGRectMake(0, 0, BadgeWidth, BadgeHeight)]) {
	}
	return self;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        // Initialization code
		[self initState];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder
{
	if (self = [super initWithCoder:decoder]) {
        // Initialization code
		[self initState];
    }
    return self;
}
- (void)initState
{
	self.value = nil;
	self.opaque = NO;
	self.pad = 2;
	self.font = [UIFont boldSystemFontOfSize:12];
	self.shadow = NO;
	self.shine = YES;
	self.alignment = UITextAlignmentCenter;
	self.fillColor = [UIColor colorWithRed:(220.0/255.0) green:(4/255.0) blue:(4/255.0) alpha:1.0];
	self.strokeColor = [UIColor whiteColor];
	self.textColor = [UIColor whiteColor];
	
	self.backgroundColor = [UIColor clearColor];
	self.userInteractionEnabled = NO;
}
- (void)dealloc
{
	[_value release];
	[_font release];
	[_fillColor release];
	[_strokeColor release];
	[_textColor release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark draw
- (void)drawRect:(CGRect)rect
{
	[super drawRect:rect];
	if (![self needShowBadge]) {
		return;
	}
	
	CGRect viewBounds = self.bounds;
	
	CGContextRef curContext = UIGraphicsGetCurrentContext();
	
	NSString* numberString = self.value;
	
	
	CGSize numberSize = [numberString sizeWithFont:self.font];
	
	CGPathRef badgePath = [self createBadgePathForTextSize:numberSize];
	
	CGRect badgeRect = CGPathGetBoundingBox(badgePath);
	
	badgeRect.origin.x = 0;
	badgeRect.origin.y  = 0;
	badgeRect.size.width = ceil( badgeRect.size.width );
	badgeRect.size.height = ceil( badgeRect.size.height );
	
	
	CGContextSaveGState( curContext );
	CGContextSetLineWidth( curContext, 2.0 );
	CGContextSetStrokeColorWithColor(  curContext, self.strokeColor.CGColor  );
	CGContextSetFillColorWithColor( curContext, self.fillColor.CGColor );
	
	CGPoint ctm;
	
	switch (self.alignment)
	{
		default:
		case UITextAlignmentCenter:
			ctm = CGPointMake( round((viewBounds.size.width - badgeRect.size.width)/2), round((viewBounds.size.height - badgeRect.size.height)/2) );
			break;
		case UITextAlignmentLeft:
			ctm = CGPointMake( 0, round((viewBounds.size.height - badgeRect.size.height)/2) );
			break;
		case UITextAlignmentRight:
			ctm = CGPointMake( (viewBounds.size.width - badgeRect.size.width), round((viewBounds.size.height - badgeRect.size.height)/2) );
			break;
	}
	
	CGContextTranslateCTM( curContext, ctm.x, ctm.y);
	
	if (self.shadow)
	{
		CGContextSaveGState( curContext );
		
		CGSize blurSize;
		blurSize.width = 0;
		blurSize.height = -2;// -2 ----->>>> 0
		UIColor* blurColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
		
		CGContextSetShadowWithColor( curContext, blurSize, 4, blurColor.CGColor );
		
		CGContextBeginPath( curContext );
		CGContextAddPath( curContext, badgePath );
		CGContextClosePath( curContext );
		
		CGContextDrawPath( curContext, kCGPathFillStroke );
		CGContextRestoreGState(curContext);
	}
	
	CGContextBeginPath( curContext );
	CGContextAddPath( curContext, badgePath );
	CGContextClosePath( curContext );
	CGContextDrawPath( curContext, kCGPathFillStroke );
	
	//
	// add shine to badge
	//
	
	if (self.shine)
	{
		CGContextBeginPath( curContext );
		CGContextAddPath( curContext, badgePath );
		CGContextClosePath( curContext );
		CGContextClip(curContext);
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGFloat shinyColorGradient[8] = {1, 1, 1, 0.8, 1, 1, 1, 0};
		CGFloat shinyLocationGradient[2] = {0, 1};
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
																	 shinyColorGradient,
																	 shinyLocationGradient, 2);
		
		CGContextSaveGState(curContext);
		CGContextBeginPath(curContext);
		CGContextMoveToPoint(curContext, 0, 0);
		
		CGFloat shineStartY = badgeRect.size.height*0.25;
		CGFloat shineStopY = shineStartY + badgeRect.size.height*0.4;
		
		CGContextAddLineToPoint(curContext, 0, shineStartY);
		CGContextAddCurveToPoint(curContext, 0, shineStopY,
								 badgeRect.size.width, shineStopY,
								 badgeRect.size.width, shineStartY);
		CGContextAddLineToPoint(curContext, badgeRect.size.width, 0);
		CGContextClosePath(curContext);
		CGContextClip(curContext);
		CGContextDrawLinearGradient(curContext, gradient,
									CGPointMake(badgeRect.size.width / 2.0, 0),
									CGPointMake(badgeRect.size.width / 2.0, shineStopY),
									kCGGradientDrawsBeforeStartLocation);
		CGContextRestoreGState(curContext);
		
		CGColorSpaceRelease(colorSpace);
		CGGradientRelease(gradient);
		
	}
	CGContextRestoreGState( curContext );
	CGPathRelease(badgePath);
	
	CGContextSaveGState( curContext );
	CGContextSetFillColorWithColor( curContext, self.textColor.CGColor );
	
	CGPoint textPt = CGPointMake( ctm.x + (badgeRect.size.width - numberSize.width)/2 , ctm.y + (badgeRect.size.height - numberSize.height)/2 );
	
	[numberString drawAtPoint:textPt withFont:self.font];
	
	CGContextRestoreGState( curContext );
	
}
- (CGPathRef)createBadgePathForTextSize:(CGSize)inSize
{
	const CGFloat kPi = M_PI;
	
	CGFloat arcRadius = ceil((inSize.height+self.pad)/2.0);
	
	CGFloat badgeWidthAdjustment = inSize.width - inSize.height/2.0;
	CGFloat badgeWidth = 2.0*arcRadius;
	
	if ( badgeWidthAdjustment > 0.0 )
	{
		badgeWidth += badgeWidthAdjustment;
	}
	else
	{
		badgeWidthAdjustment = 0;
	}
	
	CGMutablePathRef badgePath = CGPathCreateMutable();
	
	CGPathMoveToPoint( badgePath, NULL, arcRadius, 0 );
	CGPathAddArc( badgePath, NULL, arcRadius, arcRadius, arcRadius, 3.0*kPi/2.0, kPi/2.0, YES);
	CGPathAddLineToPoint( badgePath, NULL, badgeWidth-arcRadius, 2.0*arcRadius);
	CGPathAddArc( badgePath, NULL, badgeWidth-arcRadius, arcRadius, arcRadius, kPi/2.0, 3.0*kPi/2.0, YES);
	CGPathAddLineToPoint( badgePath, NULL, arcRadius, 0 );
	
	return badgePath;
	
}

#pragma mark -
#pragma mark set & redraw
- (void)setValue:(NSString *)inValue
{
	[_value release];
	_value = [inValue retain];
	
	if ([self needShowBadge]) {
		self.hidden = NO;
		[self setNeedsDisplay];
	}else {
		self.hidden = YES;
	}
}
- (NSString *)value
{
	if ([_value intValue] > 9999) {
		return @"9999+";
	}
	return _value;
}
- (CGSize)badgeSize
{
	NSString* numberString = self.value;
	
	
	CGSize numberSize = [numberString sizeWithFont:self.font];
	
	CGPathRef badgePath = [self createBadgePathForTextSize:numberSize];
	
	CGRect badgeRect = CGPathGetBoundingBox(badgePath);
	
	badgeRect.origin.x = 0;
	badgeRect.origin.y = 0;
	badgeRect.size.width = ceil( badgeRect.size.width );
	badgeRect.size.height = ceil( badgeRect.size.height );
	
	CGPathRelease(badgePath);
	
	return badgeRect.size;
}

#pragma mark -
#pragma mark check for show
- (BOOL)needShowBadge
{
	if (self.value) {
		if ([self.value isEqualToString:kBadgeNew]) {
			return YES;
		}
		if ([self.value intValue] > 0) {
			return YES;
		}
	}
	return NO;
}

@end



@implementation TBlueBadge

#define BlueBadgeWidth 150
#define BlueBadgeHeight 40
- (id)newBadgeView
{
	if (self = [self initWithFrame:CGRectMake(0, 0, BlueBadgeWidth, BlueBadgeHeight)]) {
	}
	return self;
}
- (void)initState
{
	[super initState];
	self.shadow = YES;
	self.font = [UIFont boldSystemFontOfSize:10];
	self.fillColor = [UIColor colorWithRed:0.145 green:0.514 blue:0.733 alpha:1.0];
}
- (NSString *)value
{
	return _value;
}
- (void)drawRect:(CGRect)rect
{
	//[super drawRect:rect];
	if (![self needShowBadge]) {
		return;
	}
	
	CGRect viewBounds = self.bounds;
	
	CGContextRef curContext = UIGraphicsGetCurrentContext();
	
	NSString* numberString = self.value;
	
	
	CGSize numberSize = [numberString sizeWithFont:self.font];
	
	CGPathRef badgePath = [self createBadgePathForTextSize:numberSize];
	
	CGRect badgeRect = CGPathGetBoundingBox(badgePath);
	
	badgeRect.origin.x = 0;
	badgeRect.origin.y = 0;
	badgeRect.size.width = ceil( badgeRect.size.width );
	badgeRect.size.height = ceil( badgeRect.size.height );
	
	
	CGContextSaveGState( curContext );
	CGContextSetLineWidth( curContext, 2.0 );
	CGContextSetStrokeColorWithColor(  curContext, self.strokeColor.CGColor  );
	CGContextSetFillColorWithColor( curContext, self.fillColor.CGColor );
	
	CGPoint ctm;
	
	switch (self.alignment)
	{
		default:
		case UITextAlignmentCenter:
			ctm = CGPointMake( round((viewBounds.size.width - badgeRect.size.width)/2), round((viewBounds.size.height - badgeRect.size.height)/2) );
			break;
		case UITextAlignmentLeft:
			ctm = CGPointMake( 0, round((viewBounds.size.height - badgeRect.size.height)/2) );
			break;
		case UITextAlignmentRight:
			ctm = CGPointMake( (viewBounds.size.width - badgeRect.size.width), round((viewBounds.size.height - badgeRect.size.height)/2) );
			break;
	}
	
	CGContextTranslateCTM( curContext, ctm.x, ctm.y);
	
	if (self.shadow)
	{
		CGContextSaveGState( curContext );
		
		CGSize blurSize;
		blurSize.width = -2;// -2 --->>> 0
		blurSize.height = 2;// 2 ---->>> 0
		UIColor* blurColor = [UIColor colorWithRed:(150/255.0) green:(150/255.0) blue:(150/255.0) alpha:1.0];
		
		CGContextSetShadowWithColor( curContext, blurSize, 4, blurColor.CGColor );
		
		CGContextBeginPath( curContext );
		CGContextAddPath( curContext, badgePath );
		CGContextClosePath( curContext );
		
		CGContextDrawPath( curContext, kCGPathFillStroke );
		CGContextRestoreGState(curContext);
	}
	
	CGContextBeginPath( curContext );
	CGContextAddPath( curContext, badgePath );
	CGContextClosePath( curContext );
	CGContextDrawPath( curContext, kCGPathFillStroke );
	
	//
	// add shine to badge
	//
	
	if (self.shine)
	{
		CGContextBeginPath( curContext );
		CGContextAddPath( curContext, badgePath );
		CGContextClosePath( curContext );
		CGContextClip(curContext);
		
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGFloat shinyColorGradient[8] = {1, 1, 1, 0.8, 1, 1, 1, 0};
		CGFloat shinyLocationGradient[2] = {0, 1};
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
																	 shinyColorGradient,
																	 shinyLocationGradient, 2);
		
		CGContextSaveGState(curContext);
		CGContextBeginPath(curContext);
		CGContextMoveToPoint(curContext, 0, 0);
		
		CGFloat shineStartY = badgeRect.size.height*0.25;
		CGFloat shineStopY = shineStartY + badgeRect.size.height*0.4;
		
		CGContextAddLineToPoint(curContext, 0, shineStartY);
		CGContextAddCurveToPoint(curContext, 0, shineStopY,
								 badgeRect.size.width, shineStopY,
								 badgeRect.size.width, shineStartY);
		CGContextAddLineToPoint(curContext, badgeRect.size.width, 0);
		CGContextClosePath(curContext);
		CGContextClip(curContext);
		CGContextDrawLinearGradient(curContext, gradient,
									CGPointMake(badgeRect.size.width / 2.0, 0),
									CGPointMake(badgeRect.size.width / 2.0, shineStopY),
									kCGGradientDrawsBeforeStartLocation);
		CGContextRestoreGState(curContext);
		
		CGColorSpaceRelease(colorSpace);
		CGGradientRelease(gradient);
		
	}
	CGContextRestoreGState( curContext );
	CGPathRelease(badgePath);
	
	CGContextSaveGState( curContext );
	CGContextSetFillColorWithColor( curContext, self.textColor.CGColor );
	
	CGPoint textPt = CGPointMake( ctm.x + (badgeRect.size.width - numberSize.width)/2 , ctm.y + (badgeRect.size.height - numberSize.height)/2 );
	
	[numberString drawAtPoint:textPt withFont:self.font];
	
	CGContextRestoreGState( curContext );
	
}

@end


