#import "CustomCellBackgroundView.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight);

@implementation CustomCellBackgroundView
@synthesize borderColor, fillColor, position;

#define ROUND_SIZE 5
- (BOOL) isOpaque {
    return NO;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(c, [fillColor CGColor]);
    CGContextSetStrokeColorWithColor(c, [borderColor CGColor]);
    
    if (position == CustomCellBackgroundViewPositionTop) {
        CGContextFillRect(c, CGRectMake(0.0f, rect.size.height - self.cornerRadius, rect.size.width, self.cornerRadius));
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0.0f, rect.size.height - self.cornerRadius);
        CGContextAddLineToPoint(c, 0.0f, rect.size.height);
        CGContextAddLineToPoint(c, rect.size.width, rect.size.height);
        CGContextAddLineToPoint(c, rect.size.width, rect.size.height - self.cornerRadius);
        CGContextStrokePath(c);
        CGContextClipToRect(c, CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height - self.cornerRadius));
    } else if (position == CustomCellBackgroundViewPositionBottom) {
        CGContextFillRect(c, CGRectMake(0.0f, 0.0f, rect.size.width, self.cornerRadius));
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0.0f, self.cornerRadius);
        CGContextAddLineToPoint(c, 0.0f, 0.0f);
        CGContextStrokePath(c);
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, rect.size.width, 0.0f);
        CGContextAddLineToPoint(c, rect.size.width, self.cornerRadius);
        CGContextStrokePath(c);
        CGContextClipToRect(c, CGRectMake(0.0f, self.cornerRadius, rect.size.width, rect.size.height));
    } else if (position == CustomCellBackgroundViewPositionMiddle) {
        CGContextFillRect(c, rect);
        CGContextBeginPath(c);
        CGContextMoveToPoint(c, 0.0f, 0.0f);
        CGContextAddLineToPoint(c, 0.0f, rect.size.height);
        CGContextAddLineToPoint(c, rect.size.width, rect.size.height);
        CGContextAddLineToPoint(c, rect.size.width, 0.0f);
        CGContextStrokePath(c);
        return; // no need to bother drawing rounded corners, so we return
    }
    
    // At this point the clip rect is set to only draw the appropriate
    // corners, so we fill and stroke a rounded rect taking the entire rect
    
    CGContextBeginPath(c);
    addRoundedRectToPath(c, rect, self.cornerRadius, self.cornerRadius);
    CGContextFillPath(c);  
    
    CGContextSetLineWidth(c, 1);  
    CGContextBeginPath(c);
    addRoundedRectToPath(c, rect, self.cornerRadius, self.cornerRadius);  
    CGContextStrokePath(c);     
}

- (void)dealloc {
    [borderColor release];
    [fillColor release];
    [super dealloc];
}


@end

static void addRoundedRectToPath(CGContextRef context, CGRect rect,
                                 float ovalWidth,float ovalHeight)

{
    float fw, fh;
    
    if (ovalWidth == 0 || ovalHeight == 0) {// 1
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);// 2
    
    CGContextTranslateCTM (context, CGRectGetMinX(rect),// 3
                           CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);// 4
    fw = CGRectGetWidth (rect) / ovalWidth;// 5
    fh = CGRectGetHeight (rect) / ovalHeight;// 6
    
    CGContextMoveToPoint(context, fw, fh/2); // 7
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);// 8
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);// 9
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);// 5
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // 11
    CGContextClosePath(context);// 12
    
    CGContextRestoreGState(context);// 13
}