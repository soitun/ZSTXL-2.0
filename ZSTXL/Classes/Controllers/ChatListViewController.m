//
//  ChatListViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-19.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "ChatListViewController.h"
#import "MessageListCell.h"
#import "ChatList.h"
#import "TalkViewController.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"聊天";
    
    [self initNavBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - request data

- (void)requestDataFromDB
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"loginid == %@", kAppDelegate.userId];
    NSArray *array = [ChatList findAllSortedBy:@"createtime" ascending:NO withPredicate:pred];
    
    [self.dataSourceArray addObjectsFromArray:array];
    
}

- (NSDictionary *)requestPara
{
    NSString *page = [NSString stringWithFormat:@"%d", self.page];
    
    NSDictionary *para = @{@"path": @"getMessageZsPeople.json",
                           @"page": page,
                           @"maxrow": self.maxrow,
                           @"userid": kAppDelegate.userId};
    
    return para;
}

- (void)parseData:(NSDictionary *)json
{
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"loginid == %@", kAppDelegate.userId];
    [ChatList deleteAllMatchingPredicate:pred];
    DB_SAVE();
    
    if (self.dataSourceArray && self.dataSourceArray.count > 0) {
        [self.dataSourceArray removeAllObjects];
    }
    
    
    
    NSArray *array = [json objForKey:@"MessagePeoperList"];
    for (NSDictionary *dict in array) {
        
        ChatList *list = [ChatList createEntity];
        list.userid = [dict objForKey:@"userid"];
        list.username = [dict objForKey:@"username"];
        list.picturelinkurl = [dict objForKey:@"picturelinkurl"];
        list.content = [dict objForKey:@"content"];
        list.createtime = [dict objForKey:@"createtime"];
        list.count = [[dict objForKey:@"count"] stringValue];
        list.type = [[dict objForKey:@"type"] stringValue];
        list.tel = [dict objForKey:@"tel"];
        list.loginid = kAppDelegate.userId;
        [self.dataSourceArray addObject:list];
        
    }
    
    DB_SAVE();
}

#pragma mark - table view

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"MessageListCell";
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MessageListCell" owner:self options:nil] lastObject];
    }
    
    [self configureCell:(MessageListCell *)cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(MessageListCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    ChatList *list = [self.dataSourceArray objectAtIndex:indexPath.row];
    cell.headIcon.layer.cornerRadius = 4;
    cell.headIcon.layer.masksToBounds = YES;
    [cell.headIcon setImageWithURL:[NSURL URLWithString:list.picturelinkurl] placeholderImage:[UIImage imageNamed:@"AC_L_icon.png"]];
    cell.nameLabel.text = list.username;
    cell.subjectLabel.text = list.content;
    cell.dateLabel.text = list.createtime;
    if ([list.count isEqualToString:@"0"] || ![list.count isValid]) {
        cell.unreadCountLabel.hidden = YES;
        cell.unreadCountBg.hidden = YES;
    }
    else{
        cell.unreadCountLabel.text = list.count;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatList *list = [self.dataSourceArray objectAtIndex:indexPath.row];
    TalkViewController *talkVC = [[[TalkViewController alloc] init] autorelease];
    talkVC.messageList = list;
    talkVC.isSMS = NO;
    [self.navigationController pushViewController:talkVC animated:YES];
}

@end
