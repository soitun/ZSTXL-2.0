//
//  WebViewManager.h
//  BLSY
//
//  Created by MagicZhang on 12-11-16.
//
//

#import <Foundation/Foundation.h>
#import "UIWebView+RemoveShadow.h"

#define kWebViewDidFinishedRender @"kWebViewDidFinishedRender"

#define kNormalFontSize @"<meta name='viewport' content='width=300, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no'/><style>body{margin:0;background-color:transparent;font-size:19px;line-height:25px;color:rgb(40,40,40);letter-spacing:2px;}</style>"

#define kMinFontSize @"<meta name='viewport' content='width=300, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no'/><style>body{margin:0;background-color:transparent;font-size:16px;line-height:22px;color:rgb(40,40,40);letter-spacing:1px;}</style>"

#define kMaxFontSize @"<meta name='viewport' content='width=300, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no'/><style>body{margin:0;background-color:transparent;font-size:22px;line-height:27px;color:rgb(40,40,40);letter-spacing:2px;}</style>"

typedef enum {
    FONT_TYPE_NORMAL = 0,
    FONT_TYPE_MAX    = 1,
    FONT_TYPE_MIN    = 2
} FONT_TYPE;

@interface WebViewManager : NSObject<UIWebViewDelegate>
@property (nonatomic, retain) NSMutableArray *webViewArray;
@property (nonatomic, retain) NSMutableArray *finishedArray;
@property (nonatomic, assign) UIView *contentView;
@property (nonatomic, retain) NSArray *contents;

- (id)initWithContents:(NSArray *)aContents onView:(UIView *)aContentView;
- (UIWebView *)webViewAtIndex:(NSInteger)webViewIndex;
- (CGFloat)heighForWebViewAtIndex:(NSInteger)webViewIndex;
- (void)stopManager;
- (void)renderContentForType:(FONT_TYPE)type needReloading:(BOOL)isReloading;
@end
