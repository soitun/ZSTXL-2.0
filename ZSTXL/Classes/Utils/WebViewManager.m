//
//  WebViewManager.m
//  BLSY
//
//  Created by MagicZhang on 12-11-16.
//
//

#import "WebViewManager.h"

@implementation WebViewManager
@synthesize webViewArray;
@synthesize finishedArray;
@synthesize contentView;
@synthesize contents;

- (id)initWithContents:(NSArray *)aContents onView:(UIView *)aContentView
{
    self = [super init];
    if (self) {
        self.contentView = aContentView;
        self.contents = aContents;
        self.webViewArray = [NSMutableArray array];
        self.finishedArray = [NSMutableArray array];
        
        for (int i = 0; i < [contents count]; i++) {
            
            UIWebView *webView = [[[UIWebView alloc] initWithFrame:CGRectMake(10, 0, 310, 1)] autorelease];
            webView.dataDetectorTypes = UIDataDetectorTypeNone;
            [contentView addSubview:webView];
            
            for (id subview in webView.subviews){  //webView是要被禁止滚动和回弹的UIWebView
                if ([[subview class] isSubclassOfClass: [UIScrollView class]])
                    ((UIScrollView *)subview).scrollEnabled = NO;
            }
            
            [webView makeTransparentAndRemoveShadow];
            webView.delegate = self;
            [self.webViewArray addObject:webView];
            
        }
        
        [self renderContentForType:FONT_TYPE_NORMAL needReloading:NO];
    }
    return self;
}

- (void)renderContentForType:(FONT_TYPE)type needReloading:(BOOL)isReloading {
    for (int i = 0; i < [self.webViewArray count]; i++) {
        NSDictionary *dict = [contents objectAtIndex:i];
        NSString *content = [dict objForKey:@"content"];
        
        //加空格
        content = [NSString stringWithFormat:@"　　%@", content];
        content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"</BR>　　"];
        
        UIWebView *webView = (UIWebView *)[self.webViewArray objectAtIndex:i];
//        [self webView:webView reloadContent:content withFontSizeType:type];
    
        NSString *htmlString = nil;
        if (type == FONT_TYPE_NORMAL) {
            htmlString = [kNormalFontSize stringByAppendingString:content];
        } else if (type == FONT_TYPE_MAX) {
            htmlString = [kMaxFontSize stringByAppendingString:content];
        } else {
            htmlString = [kMinFontSize stringByAppendingString:content];
        }
        [webView loadHTMLString:htmlString baseURL:nil];

        if (isReloading) {
//            for (UIWebView *aWebView in self.finishedArray) {
//                if (webView.subviews.count > 0) {
//                    CGRect frame = webView.frame;
//                    NSString *fitHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
//                    frame.size.height = [fitHeight floatValue];
//                    webView.frame = frame;
//                }
//            }
//            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWebViewDidFinishedRender object:nil];
        }
    }
}

//- (void)webView:(UIWebView *)webView reloadContent:(NSString *)content withFontSizeType:(FONT_TYPE)type {
//    NSString *htmlString = nil;
//    if (type == FONT_TYPE_NORMAL) {
//        htmlString = [kNormalFontSize stringByAppendingString:content];
//    } else if (type == FONT_TYPE_MAX) {
//        htmlString = [kMaxFontSize stringByAppendingString:content];
//    } else {
//        htmlString = [kMinFontSize stringByAppendingString:content];
//    }
//    [webView loadHTMLString:htmlString baseURL:nil];    
//}

- (CGFloat)heighForWebViewAtIndex:(NSInteger)webViewIndex {
    UIWebView *webView = (UIWebView *)[self.finishedArray objectAtIndex:webViewIndex];
    CGFloat webViewHeight = 0.0f;
    if (webView) {
        if (webView.subviews.count > 0) {
            UIView *scrollerView = [webView.subviews objectAtIndex:0];
            if (scrollerView.subviews.count > 0) {
                UIView *webDocView = scrollerView.subviews.lastObject;
                if ([webDocView isKindOfClass:[NSClassFromString(@"UIWebDocumentView") class]]) {
                    webViewHeight = webDocView.frame.size.height;
                    CGRect newFrame = webView.frame;
                    newFrame.size.height = webViewHeight;
                    webView.frame = newFrame;
                }
            }
        }        
    }
    return webViewHeight;
}

- (UIWebView *)webViewAtIndex:(NSInteger)webViewIndex {
    return [self.finishedArray objectAtIndex:webViewIndex];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.finishedArray addObject:webView];
    
    if (webView.subviews.count > 0) {
        CGRect frame = webView.frame;
        NSString *fitHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
        frame.size.height = [fitHeight floatValue];
        webView.frame = frame;
    }
        
    if ([self.finishedArray count] == [webViewArray count]) {
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWebViewDidFinishedRender object:nil];
    }
}

- (void)stopManager {
    for (UIView *webView in [self.contentView subviews]) {
        if ([webView isKindOfClass:[UIWebView class]]) {
            [(UIWebView *)webView setDelegate:nil];
            [webView removeFromSuperview];
        }
    }
}

- (void)dealloc
{
    self.contents = nil;
    self.finishedArray = nil;
    self.webViewArray = nil;
    [super dealloc];
}
@end
