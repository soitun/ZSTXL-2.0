//
//  SendMessageViewController.m
//  ZHDLTXL
//
//  Created by LiuYue on 13-4-10.
//  Copyright (c) 2013年 zxcx. All rights reserved.
//

#import "SendMessageViewController.h"
#import "GroupSendViewController.h"
#import "MyInfo.h"
#import "UserDetail.h"



@interface SendMessageViewController ()

@property (nonatomic, assign) CGFloat textViewEditingHeight;
@property (nonatomic, assign) CGFloat textViewHeight;
@property (nonatomic, retain) MyInfo *myInfo;

@end

@implementation SendMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavBar];
    [self initScrollView];
    
    self.title = @"发送短信";
    self.contactArray = [[NSMutableArray new] autorelease];
    [self.contactArray addObject:self.currentContact];
    
    
    self.view.backgroundColor = bgGreyColor;
    self.nameLabel.text = self.currentContact.username;
    self.textView.text = @"编辑短信";
    self.textView.textColor = [UIColor lightGrayColor];

    [self getMyInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [_textBgImageView release];
    [_scrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
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
    
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [replyButton setImage:[UIImage imageNamed:@"reply_mail.png"] forState:UIControlStateNormal];
    [replyButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    replyButton.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:replyButton] autorelease];
    [self.navigationItem setRightBarButtonItem:rBarButton];
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - keyboard

- (void)hideKeyBoard
{
    [self.textView resignFirstResponder];
}

-(void)keyboardWillShow:(NSNotification *)note {
    
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    CGFloat keyBoardHeight = keyboardBounds.size.height;
    
    self.scrollView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64-keyBoardHeight);
    
    [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)note {
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.scrollView.frame = CGRectMake(0, 0, 320, SCREEN_HEIGHT-64);
    [UIView commitAnimations];
}

#pragma mark - scrollView

- (void)initScrollView
{
    self.scrollView.contentSize = CGSizeMake(320, SCREEN_HEIGHT-64);
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)] autorelease];
    [self.scrollView addGestureRecognizer:tap];
}


#pragma mark - send message

- (void)getMyInfo
{
    self.myInfo = [Utility getMyInfo];
}

- (void)sendMessage:(UIButton *)sender
{
    [self hideKeyBoard];
    NSString *content = nil;
    NSString *userid = [kAppDelegate userId];
    if ([self.content isEqualToString:@"编辑短信"]) {
        content = @"";
    }
    else{
        content = self.textView.text;
    }
    
    NSLog(@"send message");
    NSMutableArray *contactArray = [[NSMutableArray alloc] init];
    [self.contactArray enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        NSLog(@"tel %@", contact.tel);
        NSNumber *contactId = [NSNumber numberWithLongLong:[contact.userid longLongValue]];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:contactId, @"id", contact.tel, @"telphone", nil];
        [contactArray addObject:dict];
    }];
    
    
    NSNumber *count = [NSNumber numberWithInt:contactArray.count];
    
    NSString *tel = self.myInfo.userDetail.tel;
    
    NSDictionary *jsonData = @{@"content":content, @"count":count, @"peoplelist":contactArray, @"tel":tel};
    NSString *jsonDataStr = [jsonData JSONString];
    NSLog(@"jsondata str %@", jsonDataStr);
    
    NSDictionary *paraDict = [NSDictionary dictionaryWithObjectsAndKeys:jsonDataStr, @"jsondata", userid, @"userid", @"sendSMSforPeople.json", @"path", nil];
    
//    NSLog(@"sms dict %@", paraDict);
    

    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[kAppDelegate window] animated:YES];
    hud.labelText = @"正在发送";
    [DreamFactoryClient getWithURLParameters:paraDict success:^(NSDictionary *json) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            [kAppDelegate showWithCustomAlertViewWithText:@"发送成功" andImageName:nil];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];

        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:[kAppDelegate window] animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
    

}

- (IBAction)addContact:(UIButton *)sender;
{
    NSLog(@"add contact");
    NSLog(@"self.contactArray %@", self.contactArray);
    GroupSendViewController *groupSendVC = [[GroupSendViewController alloc] init];
    groupSendVC.delegate = self;
    [self.navigationController pushViewController:groupSendVC animated:YES];
    [groupSendVC release];
}

#pragma mark - textView delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.textColor = [UIColor blackColor];
    if ([textView.text isEqualToString:@"编辑短信"]) {
        textView.text = @"";
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (![textView.text isValid]) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = @"编辑短信";
    }
    else{
        self.content = textView.text;
    }
}

#pragma mark - group send delegate

- (void)finishSelectGroupPeople:(NSArray *)groupPeople
{
    [self.contactArray addObjectsFromArray:groupPeople];
    
    NSMutableString *allSendTargetName = [[NSMutableString alloc] init];
    [self.contactArray enumerateObjectsUsingBlock:^(Contact *contact, NSUInteger idx, BOOL *stop) {
        [allSendTargetName appendFormat:@"%@、", contact.username];
    }];
    if ([allSendTargetName isValid]) {
        allSendTargetName = (NSMutableString *)[allSendTargetName substringToIndex:[allSendTargetName length] - 1];
    }
    NSLog(@"all name: %@", allSendTargetName);
    self.nameLabel.text = allSendTargetName;
    
}


@end
