//
//  MailBoxViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-5-31.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "MailBoxViewController.h"
#import "MailCell.h"
#import "MailSelectorView.h"
#import "MailInfoViewController.h"
#import "MailWriteViewController.h"
#import "InboxMail.h"

@interface MailBoxViewController ()

@end

@implementation MailBoxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.mailSentButton.superview) {
        [self.mailSentButton removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = bgGreyColor;
    self.mailSelectorArray = @[@"MailSelectorSent", @"MailSelectorDraft", @"MailSelectorDelete", @"MailSelectorTrash"];
    self.dataSourceArray = [NSMutableArray array];
    self.deleteDict = [NSMutableDictionary dictionary];
    self.isInbox = YES;
    
//    self.tableView.allowsSelectionDuringEditing = YES;
    [self requestInboxMail];
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
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
    
    TitleView *titleView = [[[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:nil options:nil] lastObject];
    titleView.title = @"收件箱";
    titleView.delegate = self;
    self.navigationItem.titleView = titleView;
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)titleViewTap
{
//    DLog(@"tap title view");
    if (!self.mailSentButton) {
        self.mailSentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.mailSentButton.frame = CGRectMake(180, 50, 88, 48);
        [self.mailSentButton setBackgroundImage:[UIImage imageNamed:@"mail_sent_texture"] forState:UIControlStateNormal];
        [self.mailSentButton setBackgroundImage:[UIImage imageNamed:@"mail_sent_texture_p"] forState:UIControlStateHighlighted];
        [self.mailSentButton setTitle:@"已发送" forState:UIControlStateNormal];
        [self.mailSentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.mailSentButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [self.mailSentButton addTarget:self action:@selector(mailSent) forControlEvents:UIControlEventTouchUpInside];
        [kAppDelegate.window addSubview:self.mailSentButton];
    }
}

- (void)mailSent
{
    [self.mailSentButton removeFromSuperview];
    self.mailSentButton = nil;
    self.isInbox = NO;
}

#pragma mark - request mail

- (void)requestInboxMail
{
    //测试id
    NSDictionary *para = @{@"path": @"increFecth.json",
                           @"username": @"109981",
                           @"password": @"123456",
                           @"messageNumber": @"-1",
                           @"forceUpdate": @"true"};
    
    if (self.dataSourceArray.count > 0) {
        [self.dataSourceArray removeAllObjects];
    }
    
    [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
    self.isLoading = YES;
    [MailClient getWithURLParameters:para success:^(NSDictionary *json) {
//        DLog(@"%@", json);
        self.isLoading = NO;
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        if (RETURNCODE_ISVALID(json)) {
            [self parseMail:json];
        }
        else{
            [kAppDelegate showWithCustomAlertViewWithText:[json objForKey:@"returnMessage"] andImageName:kErrorIcon];
        }
    } failure:^(NSError *error) {
        self.isLoading = NO;
        [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        DLog(@"%@", error);
    }];
}

- (void)requestSentboxMail
{
    
}

- (void)parseMail:(NSDictionary *)json
{
    NSDictionary *dict = [json objForKeyPath:@"mailBox.messageFolders.INBOX.intervalMessages"];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

        for (NSDictionary *mailDict in obj) {
            
//            DLog(@"mailDict %@", mailDict);
            
            //若本地删除，则不显示

            NSPredicate *pred = [NSPredicate predicateWithFormat:@"messageId == %@", [mailDict objForKey:@"messageId"]];
            Mail *mail = [InboxMail findFirstWithPredicate:pred];

            
            if (mail == nil) {
                InboxMail *inboxMail = [InboxMail createEntity];
                
                NSArray *keys = [mailDict allKeys];
                for (NSString *key in keys) {
                    id obj = [mailDict objForKey:key];
                    NSString *value = nil;
                    if ([obj isKindOfClass:NSClassFromString(@"NSNumber")]) {
                        value = [NSString stringWithFormat:@"%d", [obj intValue]];
                    }
                    else if([obj isKindOfClass:NSClassFromString(@"NSString")]){
                        value = obj;
                    }
                    else if([obj isKindOfClass:NSClassFromString(@"NSArray")]){
                        NSMutableString *tmp = [NSMutableString string];
                        for (NSString *str in obj) {
                            [tmp appendFormat:@"%@,", str];
                        }
                        if ([tmp isValid]) {
                            value = [tmp substringToIndex:tmp.length-1];
                        }
                    }
                    
                    [inboxMail setValue:value forKey:key];
                }
                inboxMail.content = @"";
                inboxMail.localDeleted = @"0";
                [self.dataSourceArray addObject:inboxMail];
            }
            else{
                if ([mail.localDeleted isEqualToString:@"0"]) {
                    [self.dataSourceArray addObject:mail];
                }
            }
        }
        
    }];
    
    [self.dataSourceArray sortUsingComparator:^NSComparisonResult(InboxMail * obj1, InboxMail * obj2) {
        return [obj2.sentDate compare:obj1.sentDate options:NSNumericSearch];   //降序, the fucking options
    }];
    
    DB_SAVE();
    [self.tableView reloadData];
    
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MailCell";
    MailCell *cell = (MailCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MailCell" owner:self options:nil] lastObject];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(MailCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Mail *mail = [self.dataSourceArray objectAtIndex:indexPath.row];
    if ([mail.seen isEqualToString:@"1"]) {
        cell.mailIcon.image = [UIImage imageNamed:@"mail_icon_off"];
    }else{
        cell.mailIcon.image = [UIImage imageNamed:@"mail_icon_on"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text = mail.sender;
    cell.dateLabel.text = mail.sentDateStr;
    cell.detailLabel.text = mail.subject;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MailCell *cell = (MailCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (self.tableView.editing) {
        Mail *mail = [self.dataSourceArray objectAtIndex:indexPath.row];
        DLog(@"indexpath %@, subject %@", indexPath, mail.subject);
        [self.deleteDict setObject:mail forKey:indexPath];
    }
    else{
        MailInfoViewController *mailInfoVC = [[[MailInfoViewController alloc] init] autorelease];
        mailInfoVC.mail = [self.dataSourceArray objectAtIndex:indexPath.row];
        mailInfoVC.isInbox = self.isInbox;
        mailInfoVC.mailArray = self.dataSourceArray;
        mailInfoVC.delegate = self;
        [self.navigationController pushViewController:mailInfoVC animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //多选取消
    if (self.tableView.editing) {
        [self.deleteDict removeObjectForKey:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
    }
    else{
        return UITableViewCellEditingStyleDelete;
    }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Mail *mail = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.dataSourceArray removeObject:mail];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        mail.localDeleted = @"1";
        DB_SAVE();
    }
    else{
        
    }
}



#pragma mark - mail selector view delegate

- (void)MailSelectorChooseIndexPath:(NSIndexPath *)indexPath
{
    SEL sel = NSSelectorFromString([self.mailSelectorArray objectAtIndex:indexPath.row]);
    [self performSelector:sel];
}


- (void)MailSelectorSent
{
    DLog(@"mail sent");
}

- (void)MailSelectorDraft
{
    DLog(@"mail draft");
}

- (void)MailSelectorDelete
{
    DLog(@"mail delete");
}

- (void)MailSelectorTrash
{
    DLog(@"mail trash");
}

#pragma mark - button method

- (IBAction)mailRefresh:(UIButton *)sender
{
    if (!self.isLoading) {
        [self requestInboxMail];
    }
}

- (IBAction)mailDelete:(UIButton *)sender
{
    if (self.tableView.editing == NO) {
        [self.tableView setEditing:YES animated:YES];
        
    }
    else{
        
        [self.dataSourceArray removeObjectsInArray:[self.deleteDict allValues]];

    
        [self.tableView deleteRowsAtIndexPaths:[self.deleteDict allKeys] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //捕捉动画介绍，直接reloadData会取消掉动画
        [CATransaction begin];
        [CATransaction setCompletionBlock: ^{
            [self.tableView reloadData];
        }];
        [self.tableView setEditing:NO animated:YES];
        [CATransaction commit];
        //clear DB
        
        for (Mail *mail in [self.deleteDict allValues]) {
            mail.localDeleted = @"1";
        }
        DB_SAVE();
        
        [self.deleteDict removeAllObjects];

    }
}

- (IBAction)mailWrite:(UIButton *)sender
{
    MailWriteViewController *mailWriteVC = [[[MailWriteViewController alloc] init] autorelease];
    [self.navigationController pushViewController:mailWriteVC animated:YES];
}

#pragma mark - mail info delegate

- (void)mailInfoHasRead:(Mail *)mail
{
    mail.seen = @"1";
    DB_SAVE();
    [self.tableView reloadData];
}

- (void)mailInfoHasDelete:(Mail *)mail
{
    mail.localDeleted = @"1";
    DB_SAVE();
    
    [self.dataSourceArray removeObject:mail];
    [self.tableView reloadData];
}



@end
