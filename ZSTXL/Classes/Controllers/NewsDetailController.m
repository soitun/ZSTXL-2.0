//
//  NewsDetailController.m
//  ZXCXBlyt
//
//  Created by zly on 12-4-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewsDetailController.h"
#import "NewsHeaderView.h"
#import "RegexKitLite.h"
#import "NSAttributedString+Attributes.h"
#import "WebViewManager.h"
#import "NewsInfo.h"
#import "StarNewsInfo.h"

#define kContentFont [UIFont systemFontOfSize:16]
#define kTagRegex    @"(<_image>[^\\s]+</_image>)|(<_link>[^\\s]+</_link>)"
@interface NewsDetailController ()<UIWebViewDelegate>

@end

@implementation NewsDetailController

@synthesize scrollView;
@synthesize coreTextView;
@synthesize isModelView;
@synthesize newsId;
@synthesize createrId;
@synthesize newsContent;
@synthesize btnClickReload;
@synthesize contentArray;
@synthesize delegate;
@synthesize webViewContents;
@synthesize webViewManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    index = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginRender) name:kWebViewDidFinishedRender object:nil];
    
    self.title = @"资讯详情";
    self.view.backgroundColor = bgGreyColor;
    
    [self initNavBar];
    [self initNewsToolBar];
    [self sendRequest];
}

#pragma mark - nav bar

- (void)initNavBar
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(popVC:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:backButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
}

- (void)popVC:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kWebViewDidFinishedRender object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - news tool bar

- (void)initNewsToolBar
{
    self.newsToolBar = [[[NSBundle mainBundle] loadNibNamed:@"NewsToolBar" owner:nil options:nil] lastObject];
    self.newsToolBar.delegate = self;
    self.newsToolBar.frame = CGRectMake(0, SCREEN_HEIGHT-64-44, 320, 44);
    [self.view addSubview:self.newsToolBar];
}

- (void)prepareForContentArray {
    if (self.webViewContents == nil) {
        self.webViewContents = [NSMutableArray array];
    }
    
    for (int i = 0; i < [self.contentArray count]; i++) {
        NSDictionary *dict = [self.contentArray objectAtIndex:i];
        NSString *type = [dict objForKey:@"type"];
        if ([type isEqualToString:@"label"]) {
            //加空格
            [self.webViewContents addObject:dict];
        }
    }
    
    if ([self.webViewContents count] > 0) {
        self.webViewManager = [[[WebViewManager alloc] initWithContents:self.webViewContents onView:self.scrollView] autorelease];
    }
}

- (void)beginRender {
    
    
    NSInteger labelIndex = 0;
    
    CGFloat offset = 74.0f;
    for (int i = 0; i < [self.contentArray count]; i++) {
        NSDictionary *dict = [self.contentArray objectAtIndex:i];
        NSString *type = [dict objForKey:@"type"];
        NSString *content = [dict objForKey:@"content"];
        
        //加空格
        if ([type isEqualToString:@"label"]) {
            UIWebView *webView = [self.webViewManager webViewAtIndex:labelIndex];
        
            CGFloat height = webView.frame.size.height;
            labelIndex++;
            
            webView.frame = CGRectMake(10, offset, 310, height);
            offset += height + 10;
        } else if ([type isEqualToString:@"image"]) {
            content = [NSString stringWithFormat:@"        %@", content];
            content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"\n        "];

            NSString *mutableContent = [[content mutableCopy] autorelease];
            NSString *filteredContent = [mutableContent stringByReplacingOccurrencesOfRegex:@"<_image>|<_link>|</_image>|</_link>" withString:@""];
            self.imageView = [[[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageByName:@"new_default"] delegate:nil] autorelease];
            [Utility addShadow:self.imageView];
            offset += 10; //增加空行
            self.imageView.frame = CGRectMake(10, offset, 300, 225);
            [scrollView addSubview:self.imageView];
            self.imageView.imageURL = [NSURL URLWithString:[filteredContent removeSpace]];
            offset += self.imageView.frame.size.height + 10;
            offset += 10; //增加空行
            
        } else if ([type isEqualToString:@"link"]) {
            content = [NSString stringWithFormat:@"        %@", content];
            content = [content stringByReplacingOccurrencesOfString:@"\n" withString:@"\n        "];

            NSString *mutableContent = [[content mutableCopy] autorelease];
            NSString *filteredContent = [mutableContent stringByReplacingOccurrencesOfRegex:@"<_image>|<_link>|</_image>|</_link>" withString:@""];
            NSRange range = [filteredContent rangeOfString:@"|"];
            if (range.length > 0) {
                NSString *linkString = [filteredContent substringFromIndex:range.location + 1];
                linkString = [NSString stringWithFormat:@"        %@", linkString];
                
                OHAttributedLabel *contentLabel = [[[OHAttributedLabel alloc] initWithFrame:CGRectMake(10, offset, 300, 9999)] autorelease];
                contentLabel.lineSpace = 8;
                contentLabel.delegate = self;
                contentLabel.backgroundColor = [UIColor clearColor];
                NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:linkString];
                [attrStr setTextColor:[UIColor blueColor]];
                [attrStr setFont:[UIFont fontWithName:@"Heiti SC" size:17]];
                contentLabel.attributedText = attrStr;
                contentLabel.textAlignment = UITextAlignmentLeft;
                contentLabel.extendBottomToFit = YES;
                contentLabel.lineBreakMode = UILineBreakModeWordWrap;
                [contentLabel sizeToFit];
                offset += contentLabel.frame.size.height + 10;
                
                NSString *urlString = [NSString stringWithFormat:@"user://%@", [[content removeSpace] md5]];
                [contentLabel addCustomLink:[NSURL URLWithString:urlString] inRange:[linkString rangeOfString:linkString]];
                [scrollView addSubview:contentLabel];
            }
        } else {
            NSLog(@"error");
        }
    }
    
    scrollView.contentSize = CGSizeMake(320, offset);
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIView animateWithDuration:0.2 animations:^{
        self.scrollView.alpha = 1;
    }];
}

- (void)refreshContent
{
    [self.webViewContents removeAllObjects];
    [self.webViewManager stopManager];
    if (self.scrollView && self.scrollView.superview) {
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
    }
    [self.imageView removeFromSuperview];
    self.imageView = nil;
}

- (void)initCoretextview {
    
    //add coretextview
    self.scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-64-44)] autorelease];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:scrollView];
    self.scrollView.alpha = 0;
    
    NSArray *splitArray = [self arrayBySplitContent:self.newsContent];
    self.contentArray = splitArray;
}

- (NSArray *)arrayBySplitContent:(NSString *)content {
    NSArray *splitArray = [content componentsSeparatedByRegex:@"(<_image>[^\\s]+</_image>)|(<_link>[^\\s]+</_link>)"];
    NSMutableArray *final = [NSMutableArray array];
    for (NSString *str in splitArray) {
        NSString *tempStr = [str removeNewLine];
        if ([tempStr isValid] && ![tempStr isEqualToString:@""]) {
            NSDictionary *dict = nil;
            if ([tempStr hasPrefix:@"<_image>"]) {
                dict = [NSDictionary dictionaryWithObjectsAndKeys:tempStr, @"content", @"image", @"type", nil];
            } else if ([tempStr hasPrefix:@"<_link>"]) {
                dict = [NSDictionary dictionaryWithObjectsAndKeys:tempStr, @"content", @"link", @"type", nil];                
            } else {
                dict = [NSDictionary dictionaryWithObjectsAndKeys:tempStr, @"content", @"label", @"type", nil];
            }
            [final addObject:dict];
        }
    }
    return final;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[scrollView setContentSize:CGSizeMake(CGRectGetWidth(scrollView.bounds), CGRectGetHeight(coreTextView.frame) + 40)];
}

- (void)sendRequest {
    self.btnClickReload.hidden = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"getInformationDetail.json", @"path", newsId, @"informationid", nil];
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        
        DLog(@"news %@", [json objForKey:@"InformationDetail.content"]);
        
        if (RETURNCODE_ISVALID(json)) {

            NSString *tempContent = [json objForKeyPath:@"InformationDetail.content"];
            if ([tempContent isValid]) {
                self.newsContent = [NSString stringWithFormat:@"\n%@（完）\n", tempContent];
            }
            [self initCoretextview];
            [self prepareForContentArray];
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewsHeaderView" owner:self options:nil];
            NewsHeaderView *header = (NewsHeaderView *)[nib objectAtIndex:0];
            header.labTitle.text = [json objForKeyPath:@"InformationDetail.informationtitle"];
            header.labSubtitle.text = [json objForKeyPath:@"InformationDetail.publishedtime"];
            [self.scrollView addSubview:header];
            [self.btnClickReload removeFromSuperview];
            self.btnClickReload = nil;
        } else {
            self.btnClickReload.hidden = NO;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSError *error) {
        self.btnClickReload.hidden = NO;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
    //请求是否收藏过
    NSString *myUid = [PersistenceHelper dataForKey:kUserId];
    dict = [NSDictionary dictionaryWithObjectsAndKeys:@"getCollectState.json", @"path", myUid, @"userid", newsId, @"commid", nil];
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            NSString *status = [[json objForKey:@"state"] stringValue];
            if ([status isEqualToString:@"0"]) {
                [self.newsToolBar.newsStarButton setImage:[UIImage imageByName:@"news_star_off"] forState:UIControlStateNormal];
                isNewsCollect = NO;
            } else {
                [self.newsToolBar.newsStarButton setImage:[UIImage imageByName:@"news_star"] forState:UIControlStateNormal];
                isNewsCollect = YES;
            }
            
            [self updateNewsStarInDB];
            
        } else {
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:kErrorIcon];
        }
    } failure:^(NSError *error) {
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    
}

- (void)updateNewsStarInDB
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"newsid == %@", self.newsId];
    StarNewsInfo *starNewsInfo = [StarNewsInfo findFirstWithPredicate:pred];
    if (isNewsCollect) {
        if (starNewsInfo == nil) {
            starNewsInfo = [StarNewsInfo createEntity];
            NSDictionary *dict = [self.newsArray objectAtIndex:self.newsIndex];
            [starNewsInfo initWithDict:dict];
        }
        
        starNewsInfo.type = @"1";
        DB_SAVE();
        
        DLog(@"star news count %d", [NewsInfo findAll].count);
    }
    else{
        if (starNewsInfo) {
            [starNewsInfo deleteEntity];
            DB_SAVE();
        }
    }
}

- (void)viewDidUnload
{
    [self setBtnClickReload:nil];
    [super viewDidUnload];
}

- (IBAction)clickReloadAction:(id)sender {
    [self sendRequest];
}

-(UIColor*)colorForLink:(NSTextCheckingResult*)link underlineStyle:(int32_t*)pUnderline {
    *pUnderline = kCTUnderlineStyleNone;    
    return [UIColor blueColor];    
}

#pragma mark - news tabbar delegate

- (void)newsStar
{
    NSString *myUid = [PersistenceHelper dataForKey:kUserId];
    NSDictionary *dict = nil;
    if (isNewsCollect) {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:@"delCollect.json", @"path", myUid, @"userid", newsId, @"commid", nil];
    } else {
        dict = [NSDictionary dictionaryWithObjectsAndKeys:@"addCollect.json", @"path", myUid, @"userid", newsId, @"commid", nil];
    }
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            if (isNewsCollect) {
                [kAppDelegate showWithCustomAlertViewWithText:@"已经取消收藏" andImageName:nil];
                [self.newsToolBar.newsStarButton setImage:[UIImage imageByName:@"news_star"] forState:UIControlStateNormal];
                isNewsCollect = NO;
            } else {
                [kAppDelegate showWithCustomAlertViewWithText:@"添加收藏成功" andImageName:nil];
                [self.newsToolBar.newsStarButton setImage:[UIImage imageByName:@"news_star_off"] forState:UIControlStateNormal];
                isNewsCollect = YES;
            }
            
            [self updateNewsStarInDB];
            
        } else {
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)newsUp
{
    if (self.newsIndex == 0) {
        [kAppDelegate showWithCustomAlertViewWithText:@"到顶了，亲" andImageName:nil];
        return;
    }else{
        [self refreshContent];
        self.newsIndex--;
        self.newsId = [[self.newsArray objectAtIndex:self.newsIndex] objForKey:@"id"];
        [self sendRequest];
    }
}

- (void)newsDown
{
    if (self.newsIndex == self.newsArray.count-1) {
        [kAppDelegate showWithCustomAlertViewWithText:@"没有了，亲" andImageName:nil];
        return;
    }else{
        [self refreshContent];
        self.newsIndex++;
        self.newsId = [[self.newsArray objectAtIndex:self.newsIndex] objForKey:@"id"];
        [self sendRequest];
    }
}

- (void)newsContact
{
    
}

- (void)dealloc {
    self.webViewManager = nil;
    self.webViewContents = nil;
    [contentArray release];
    [newsContent release];
	[coreTextView release];
	[scrollView release];
    self.createrId          = nil;
    self.newsId             = nil;
    [btnClickReload release];
    [super dealloc];
}
@end
