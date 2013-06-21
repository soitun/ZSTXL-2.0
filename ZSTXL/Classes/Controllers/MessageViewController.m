//
//  MessageViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-21.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#define PLACEHOLDER_COLOR	RGBCOLOR(150, 150, 150)
#define SEND_MESSAGE_BUTTON_FONT [UIFont boldSystemFontOfSize:15]
#define TIME_SPLIT_CELL_TAG  @"44444444"

#import "MessageViewController.h"
#import "OtherTalkCell.h"
#import "MyTalkCell.h"


@interface MessageViewController ()

@end

@implementation MessageViewController

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
    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = bgGreyColor;
    self.dataSourceArray = [NSMutableArray array];
    
    NSString *title = [NSString stringWithFormat:@"与%@留言", self.username];
    
    
    self.title = title;
    self.page = 0;
    self.maxrow = @"5";
    
    [self initGrowTextView];
    [self initNavigationBar];
    [self talkHistory];
    [self initTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - grow text view

- (void)initGrowTextView {
    self.containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, 320, 49)] autorelease];
    
    
    self.textView = [[[HPGrowingTextView alloc] initWithFrame:CGRectMake(57, 7, 204, 35) placeHolder:@"请输入要发送的消息" placeholderColor:PLACEHOLDER_COLOR] autorelease];
    self.textView.contentInset = UIEdgeInsetsMake(0, 1, 0, 1);
	self.textView.minNumberOfLines = 1;
	self.textView.maxNumberOfLines = 4;
	self.textView.returnKeyType = UIReturnKeyDefault;
	self.textView.font = [UIFont systemFontOfSize:17.0f];
	self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.textView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.containerView];
	
    UIImage *rawEntryBackground = [UIImage imageByName:@"d_textfield_bg"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[[UIImageView alloc] initWithImage:entryBackground] autorelease];
    entryImageView.frame = CGRectMake(55, 5, 208, 40);
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageByName:@"d_inputbar_bg"];
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:rawBackground] autorelease];
    imageView.frame = CGRectMake(0, 0, self.containerView.frame.size.width, self.containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [self.containerView addSubview:imageView];
    [self.containerView addSubview:entryImageView];
    [self.containerView addSubview:self.textView];
    
    UIImage *sendBtnBackground = [[UIImage imageByName:@"d_send_button.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageByName:@"d_send_button_p.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(self.containerView.frame.size.width - 47, 5, 40, 40);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"发送" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = SEND_MESSAGE_BUTTON_FONT;
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(addMessage) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[self.containerView addSubview:doneBtn];
    
    UIButton *faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"d_face"] forState:UIControlStateNormal];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"d_face_p"] forState:UIControlStateHighlighted];
    [faceButton addTarget:self action:@selector(addFace) forControlEvents:UIControlEventTouchUpInside];
    faceButton.frame = CGRectMake(6, 5, 40, 40);
    faceButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.containerView addSubview:faceButton];
    
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    self.doneButton = doneBtn;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.containerView.frame = r;
}

#pragma mark - nav bar

- (void)initNavigationBar {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 30);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageByName:@"retreat.png"] forState:UIControlStateNormal];
    UIBarButtonItem *button1 = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    self.navigationItem.leftBarButtonItem = button1;
}

- (void)backAction {
    [self.timer invalidate];
    self.timer = nil;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - init timer

- (void)initTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(getMessageLoop:) userInfo:nil repeats:YES];
}

- (NSString *)lastTalkTime {
    
    return self.lastTime ? self.lastTime : @"";
}

- (void)getMessageLoop:(NSTimer*)theTimer {
    
    if ([[self lastTalkTime] isValid]) {
        
        NSDictionary *para = [self getMessageLoopPara];

        
        [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
            NSArray *array = [json objForKey:@"MessageList"];
            if (array && [array count] > 0) {
                [array enumerateObjectsUsingBlock:^(NSDictionary *dict, NSUInteger idx, BOOL *stop) {
                    
                }];
                [self.tableView reloadData];
                
                if ([self.dataSourceArray count] > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
            self.lastTime = [[json objForKey:@"LastTime"] stringValue];
            
        } failure:^(NSError *error) {
            
        }];
    }    
}

- (NSDictionary *)getMessageLoopPara
{
    return nil;
}

#pragma mark - talk history

- (void)talkHistory
{
    [self.dataSourceArray removeAllObjects];
    [self.tableView reloadData];
    
    NSDictionary *para = [self talkHistoryPara];
    
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        
        DLog(@"talk history %@", json);
        @try {
            if (RETURNCODE_ISVALID(json)) {
                self.lastTime = [[json objForKey:@"LastTime"] stringValue];
                NSArray *array = [json objForKey:@"MessageList"];
                for (NSDictionary *dict in array) {
                    
                    
                }
                [self.tableView reloadData];
                if ([self.dataSourceArray count] > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
        }
        @catch (NSException *exception) {
            
        }
    } failure:^(NSError *error) {
        NSLog(@"error : %@", error);
    }];    
}

- (NSDictionary *)talkHistoryPara
{
    return nil;
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSString *uid = [dict objForKey:@"userid"];
    if ([uid isEqualToString:self.userId]) {
        
    }
    else{
        
    }
    
    return 0.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSourceArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSString *uid = [dict objForKey:@"userid"];
    static NSString *kOtherCell  = @"OtherTalkCell";
    static NSString *kMyCell     = @"MyTalkCell";
    
    UITableViewCell *cell = nil;
        
    if ([uid isEqualToString:self.userId]) {
        cell = (OtherTalkCell *)[tableView dequeueReusableCellWithIdentifier:kOtherCell];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"OtherTalkCell" owner:self options:nil];
            cell = (OtherTalkCell *)[nib objectAtIndex:0];
            
        }
    } else {
        cell = (MyTalkCell *)[tableView dequeueReusableCellWithIdentifier:kMyCell];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyTalkCell" owner:self options:nil];
            cell = (MyTalkCell *)[nib objectAtIndex:0];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    NSString *time = [self chatTime:dict atIndexPath:indexPath];
    
    
    if ([cell isKindOfClass:[OtherTalkCell class]]) {
        [[(OtherTalkCell *)cell labContent] setText:self.content];
        [[(OtherTalkCell *)cell labTime] setText:time];
        [((OtherTalkCell *)cell).avatar setImageWithURL:[NSURL URLWithString:self.avatarUrl] placeholderImage:[UIImage imageByName:@"avatar"]];
    } else{
        [[(MyTalkCell *)cell labContent] setText:self.content];
        [[(MyTalkCell *)cell labTime] setText:time];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

- (NSString *)chatTime:(id)date atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - add message

- (void)addMessage
{
    NSString *content = [[self.textView text] removeSpaceAndNewLine];
    if (![content isValid] || [content isEqualToString:@"请输入要发送的消息"]) {
        [kAppDelegate showWithCustomAlertViewWithText:@"尚未输入信息" andImageName:nil];
        return;
    }
    
    [self.textView resignFirstResponder];
    
    self.doneButton.enabled = NO;
    
    
    NSDictionary *para = [self addMessagePara];
    
    
    DLog(@"add message dict %@", para);
    [DreamFactoryClient getWithURLParameters:para success:^(NSDictionary *json) {
        if ([GET_RETURNCODE(json) isEqualToString:@"0"]) {
            self.doneButton.enabled = YES;
            [self.textView clearText];
            
            [self.tableView reloadData];
            if ([self.dataSourceArray count] > 0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
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

- (NSDictionary *)addMessagePara
{
    return nil;
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
	CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    CGRect tableViewFrame = self.tableView.frame;
    CGFloat viewHeight = SCREEN_HEIGHT-64;
    
    
    tableViewFrame.size.height = viewHeight - keyboardBounds.size.height - 49;
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
    //    NSLog(@"containerView : %@", containerView);
	self.containerView.frame = containerFrame;
	self.tableView.frame = tableViewFrame;
	// commit animations
	[UIView commitAnimations];
    
    if ([self.dataSourceArray count] > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([self.dataSourceArray count]-1) inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

-(void)keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = self.containerView.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
	
    CGRect tableViewFrame = self.tableView.frame;
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
	self.containerView.frame = containerFrame;
	self.tableView.frame = tableViewFrame;
	// commit animations
	[UIView commitAnimations];
}


@end
