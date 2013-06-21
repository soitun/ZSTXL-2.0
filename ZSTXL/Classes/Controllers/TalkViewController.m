//
//  TalkViewController.m
//  ZXCXBlyt
//
//  Created by zly on 12-3-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define PLACEHOLDER_COLOR	RGBCOLOR(150, 150, 150)
#define SEND_MESSAGE_BUTTON_FONT [UIFont boldSystemFontOfSize:15]
#define TIME_SPLIT_CELL_TAG  @"44444444"

#import "TalkViewController.h"
#import "OtherTalkCell.h"
#import "MyTalkCell.h"
#import "TimeSplitCell.h"
#import "UIImage+RoundedCorner.h"
#import "ChatRecord.h"
#import "SMSRecord.h"
#import "UserDetail.h"

@interface TalkViewController ()

@end

@implementation TalkViewController

@synthesize mTableView;
@synthesize dataSourceArray;
@synthesize containerView;
@synthesize timer;
@synthesize lastTime;
@synthesize doneButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mTableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = bgGreyColor;
    self.dataSourceArray = [NSMutableArray array];
    
    NSString *title = nil;
    
    if (self.messageList) {
        title = [NSString stringWithFormat:@"与%@留言", self.messageList.username];
    }
    else{
        title = [NSString stringWithFormat:@"与%@留言", self.username];
    }

    
    self.title = title;
    self.page = 0;
    self.maxrow = @"5";
    
    [self initGrowTextView];
    [self initNavigationBar];
    [self talkHistory];
    [self initTimer];
}

- (void)initTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getMessageLoop:) userInfo:nil repeats:YES];
}

- (NSString *)lastTalkTime {

    return self.lastTime ? self.lastTime : @"";
}

- (void)getMessageLoop:(NSTimer*)theTimer {
    
    if ([[self lastTalkTime] isValid]) {
        NSString *userid = [PersistenceHelper dataForKey:kUserId];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"getMessageloop.json", @"path", userid, @"userid", fid, @"destuserid", [self lastTalkTime], @"time", nil];
        NSDictionary *para = nil;
        if (self.isSMS) {
            para = @{@"path": @"getSmsMessageloop.json",
                     @"userid": kAppDelegate.userId,
                     @"destuserid": self.messageList.userid,
                     @"time": [self lastTalkTime]};
            [para retain];
        }
        else{
            para = @{@"path": @"getMessageloop.json",
                     @"userid": kAppDelegate.userId,
                     @"destuserid": self.messageList.userid,
                     @"time": [self lastTalkTime]};
            [para retain];
        }
        
        
        
        [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
            NSArray *array = [json objForKey:@"MessageList"];
            if (array && [array count] > 0) {
//                [self.dataSourceArray addObjectsFromArray:array];
                [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                    ChatRecord *chatRecord = [ChatRecord createEntity];
                    chatRecord.content = [dict objForKey:@"content"];
                    chatRecord.time = [[dict objForKey:@"time"] stringValue];
                    chatRecord.userid = [[dict objForKey:@"userid"] stringValue];
                    chatRecord.loginid = kAppDelegate.userId;
                    [self.dataSourceArray addObject:chatRecord];
                    DB_SAVE();
                }];
                [self.mTableView reloadData];
                
                if ([self.dataSourceArray count] > 0) {
                    [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
         self.lastTime = [[json objForKey:@"LastTime"] stringValue];
         
        } failure:^(NSError *error) {
            
        }];
        
        [para release];
    }    
}
                  
- (void)viewDidUnload
{
    [self.timer invalidate];
    self.timer = nil;
    [self setMTableView:nil];
    [super viewDidUnload];
}

- (void)talkHistory {
    [self.dataSourceArray removeAllObjects];
    [self.mTableView reloadData];
    
    NSString *page = [NSString stringWithFormat:@"%d", self.page];
    
    
    NSDictionary *para = nil;
    if (self.isSMS) {
        para = @{@"path": @"getSmsMessage.json",
                 @"page": page,
                 @"maxrow": self.maxrow,
                 @"userid": kAppDelegate.userId,
                 @"destuserid": self.messageList.userid};
    }
    else{
        para = @{@"path": @"getMessage.json",
                 @"page": page,
                 @"maxrow": self.maxrow,
                 @"userid": kAppDelegate.userId,
                 @"destuserid": self.messageList.userid};
    }
    
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {

//        NSLog(@"talk history %@", json);
        @try {
            if (RETURNCODE_ISVALID(json)) {
                self.lastTime = [[json objForKey:@"LastTime"] stringValue];
                NSArray *array = [json objForKey:@"MessageList"];
                for (NSDictionary *dict in array) {
                    
                    MessageRecord *messageRecord = nil;
                    if (self.isSMS) {
                        messageRecord = [SMSRecord createEntity];
                    }
                    else{
                        messageRecord = [ChatRecord createEntity];
                    }
                    
                    
                    messageRecord.content = [dict objForKey:@"content"];
                    messageRecord.time = [[dict objForKey:@"time"] stringValue];
//                    NSLog(@"server time %@", chatRecord.time);
                    messageRecord.userid = [[dict objForKey:@"userid"] stringValue];
                    messageRecord.loginid = kAppDelegate.userId;
                    [self.dataSourceArray insertObject:messageRecord atIndex:0];
                    DB_SAVE();
                    
                    
                }
                [self.mTableView reloadData];
                if ([self.dataSourceArray count] > 0) {
                    [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }            
        }
        @catch (NSException *exception) {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];    
}

- (void)addMessage {

    NSString *content = [[textView text] removeSpaceAndNewLine];
    if (![content isValid] || [content isEqualToString:@"请输入要发送的消息"]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"尚未输入信息" andImageName:nil];
        return;
    }
    
    [textView resignFirstResponder];
    
    self.doneButton.enabled = NO;
    
    
    NSDictionary *para = nil;
    if (self.isSMS) {
        
        MyInfo *myInfo = [Utility getMyInfo];
        
        NSDictionary *contentJson = @{@"content": content,
                                      @"count": [NSNumber numberWithInt:1],
                                      @"peoplelist": @[@{@"id": self.messageList.userid, @"telphone": [self.messageList.tel removeSpace]}],
                                      @"tel": myInfo.userDetail.tel};
        
        para = @{@"userid": kAppDelegate.userId,
                 @"jsondata": [contentJson JSONString],
                 @"path": @"sendSMSforPeople.json"};
        
        [para retain];
        
    }
    else{
        para = @{@"path": @"addMessage.json",
                 @"userid": kAppDelegate.userId,
                 @"destuserid": self.messageList.userid,
                 @"content": content};
        
        [para retain];
    }
    
    
    NSLog(@"add message dict %@", para);
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        if ([GET_RETURNCODE(json) isEqualToString:@"0"]) {
            self.doneButton.enabled = YES;
            [textView clearText];
            
            
            MessageRecord *messageRecord = nil;
            
            if (self.isSMS) {
                messageRecord = [SMSRecord createEntity];
            }
            else{
                messageRecord = [ChatRecord createEntity];
            }
            
            messageRecord.content = content;
            messageRecord.time = [NSString stringWithFormat:@"%.lf", [[NSDate date] timeIntervalSince1970]*1000];
            messageRecord.userid = kAppDelegate.userId;
            messageRecord.loginid = kAppDelegate.userId;
            [self.dataSourceArray addObject:messageRecord];
            DB_SAVE();

            [self.mTableView reloadData];
            if ([self.dataSourceArray count] > 0) {
                [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        } else {
            self.doneButton.enabled = YES;
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        self.doneButton.enabled = YES;
        [kAppDelegate showWithCustomAlertViewWithText:@"发送失败，请重试" andImageName:kErrorIcon];
    }];
    
    [para release];
}

- (void)addFace
{
    DLog(@"add face");
}

- (void)dealloc {
    [doneButton release];
    [lastTime release];
    [fAvatarUrl release];
    [fid release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [mTableView release];
    [super dealloc];
}

- (void)backAction {
    [self.timer invalidate];
    self.timer = nil;

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initNavigationBar {

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageByName:@"retreat.png"] forState:UIControlStateNormal];
    UIBarButtonItem *button1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.leftBarButtonItem = button1;
}


- (void)initGrowTextView {
    containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, 320, 49)] autorelease];
    

    textView = [[[HPGrowingTextView alloc] initWithFrame:CGRectMake(57, 7, 204, 35) placeHolder:@"请输入要发送的消息" placeholderColor:PLACEHOLDER_COLOR] autorelease];
    textView.contentInset = UIEdgeInsetsMake(0, 1, 0, 1);
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 4;
	textView.returnKeyType = UIReturnKeyDefault;
	textView.font = [UIFont systemFontOfSize:17.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageByName:@"d_textfield_bg"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
    entryImageView.frame = CGRectMake(55, 5, 208, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageByName:@"d_inputbar_bg"];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:rawBackground] autorelease];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:entryImageView];
    [containerView addSubview:textView];
    
    UIImage *sendBtnBackground = [[UIImage imageByName:@"d_send_button.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageByName:@"d_send_button_p.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 47, 5, 40, 40);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = SEND_MESSAGE_BUTTON_FONT;
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(addMessage) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:doneBtn];
    
    UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"d_face"] forState:UIControlStateNormal];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"d_face_p"] forState:UIControlStateHighlighted];
    [faceButton addTarget:self action:@selector(addFace) forControlEvents:UIControlEventTouchUpInside];
    faceButton.frame = CGRectMake(6, 5, 40, 40);
    faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [containerView addSubview:faceButton];
    
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;    
    
    self.doneButton = doneBtn;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageRecord *messageRecord = [self.dataSourceArray objectAtIndex:indexPath.row];

    NSString *uid = messageRecord.userid;
    NSString *content = messageRecord.content;
    if ([uid isEqualToString:fid]) {
        return [OtherTalkCell heightForCellWithContent:content];    
    } else if ([uid isEqualToString:TIME_SPLIT_CELL_TAG]) {
        return 20;
    } else {
        return [MyTalkCell heightForCellWithContent:content];
    }    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *kOtherCell  = @"OtherTalkCell";
    static NSString *kMyCell     = @"MyTalkCell";
    static NSString *kTimeCell   = @"TimeSplitCell";
    
    UITableViewCell *cell = nil;

    MessageRecord *messageRecord = [self.dataSourceArray objectAtIndex:indexPath.row];


    NSString *uid = messageRecord.userid;
    
    if ([uid isEqualToString:fid]) {
        cell = (OtherTalkCell *)[_tableView dequeueReusableCellWithIdentifier:kOtherCell];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OtherTalkCell" owner:self options:nil];
            cell = (OtherTalkCell *)[nib objectAtIndex:0];

        }
    } else if ([uid isEqualToString:TIME_SPLIT_CELL_TAG]) {
        cell = (TimeSplitCell *)[_tableView dequeueReusableCellWithIdentifier:kTimeCell];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TimeSplitCell" owner:self options:nil];
            cell = (TimeSplitCell *)[nib objectAtIndex:0];
        }
    } else {
        cell = (MyTalkCell *)[_tableView dequeueReusableCellWithIdentifier:kMyCell];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyTalkCell" owner:self options:nil];
            cell = (MyTalkCell *)[nib objectAtIndex:0];
        }        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    ChatRecord *chatRecord = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSString *content = chatRecord.content;
    NSLog(@"chatRecord.time %@", chatRecord.time);
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:chatRecord.time.doubleValue/1000];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy年M月d日 H:mm"];
    NSString *time = [dateFormatter stringFromDate:date];
    
    if ([cell isKindOfClass:[OtherTalkCell class]]) {
        [[(OtherTalkCell *)cell labContent] setText:content];
        [[(OtherTalkCell *)cell labTime] setText:time];
        [((OtherTalkCell *)cell).avatar setImageWithURL:[NSURL URLWithString:self.messageList.picturelinkurl] placeholderImage:[UIImage imageByName:@"avatar"]];
    } else if ([cell isKindOfClass:[TimeSplitCell class]]) {
        [[(TimeSplitCell *)cell labTime] setText:content];
    } else{
        [[(MyTalkCell *)cell labContent] setText:content];
        [[(MyTalkCell *)cell labTime] setText:time];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([textView isFirstResponder]) {
        [textView resignFirstResponder];
    }
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}


#pragma mark - keyboard

-(void)keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    CGRect tableViewFrame = self.mTableView.frame;
    CGFloat viewHeight = SCREEN_HEIGHT-64;
    
    
    tableViewFrame.size.height = viewHeight - keyboardBounds.size.height - 49;
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
    //    NSLog(@"containerView : %@", containerView);
	containerView.frame = containerFrame;
	self.mTableView.frame = tableViewFrame;
	// commit animations
	[UIView commitAnimations];
    
    if ([self.dataSourceArray count] > 0) {
        [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

-(void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
    CGRect tableViewFrame = self.mTableView.frame;
    CGFloat viewHeight = 0.f;
    if (IS_IPHONE_5) {
        viewHeight = 548.f;
    }
    else{
        viewHeight = 460;
    }
    
    tableViewFrame.size.height = viewHeight - 44 - 49;
    
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	self.mTableView.frame = tableViewFrame;
	// commit animations
	[UIView commitAnimations];
}

@end
