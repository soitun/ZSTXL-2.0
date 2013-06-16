//
//  InviteFriendViewController.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-5.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "InviteFriendCell.h"
#import <AddressBook/AddressBook.h>
#import <MessageUI/MessageUI.h>

@interface InviteFriendViewController ()

@end

@implementation InviteFriendViewController

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
    
    self.title = @"邀请";
    self.selectArray = [NSMutableArray array];
    self.selectMax = 50;
    
    [self initNavBar];
    [self initContactDict];
    [self requestAddressBook];
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

- (void)initContactDict
{
    self.contactDict = [[[NSMutableDictionary alloc] init] autorelease];
    NSArray *indexTitleArray = [[UILocalizedIndexedCollation currentCollation] sectionTitles];
    [indexTitleArray enumerateObjectsUsingBlock:^(NSString *indexTitle, NSUInteger idx, BOOL *stop) {
        [self.contactDict setObject:[NSMutableArray array] forKey:indexTitle];
    }];
    
    self.sectionArray = [NSMutableArray array];
}

#pragma mark - get contact

- (void)requestAddressBook
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) {
        
        // we're on iOS 6
        NSLog(@"on iOS 6 or later, trying to grant access permission");
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }
    else { // we're on iOS 5 or older
        
        NSLog(@"on iOS 5 or older, it is OK");
        accessGranted = YES;
    }
    
    if (accessGranted) {
        NSLog(@"get granted");
        
        ABAddressBookRef addressBook = ABAddressBookCreate( );
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople( addressBook );
        CFIndex nPeople = ABAddressBookGetPersonCount( addressBook );
        
        NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
        [jsonDict setObject:kAppDelegate.userId forKey:@"userid"];
        [jsonDict setObject:kAppDelegate.uuid forKey:@"uuid"];
        for ( int i = 0; i < nPeople; i++ )
        {
            ABRecordRef ref = CFArrayGetValueAtIndex( allPeople, i );
            NSString *firstname = ABRecordCopyValue(ref, kABPersonFirstNameProperty);
            NSString *lastname = ABRecordCopyValue(ref, kABPersonLastNameProperty);
            
            NSString *fullname = nil;
            if (![firstname isValid] && ![lastname isValid]) {
                continue;
            }
            
            else if ([firstname isValid] && [lastname isValid]) {
                fullname = [NSString stringWithFormat:@"%@%@",lastname,firstname];
            }
            
            else if ([firstname isValid] && ![lastname isValid]) {
                fullname = firstname;
            }
            
            else if (![firstname isValid] && [lastname isValid]) {
                fullname = lastname;
            }
            
            
            ABMultiValueRef tels = ABRecordCopyValue(ref, kABPersonPhoneProperty);
            CFIndex telCount = ABMultiValueGetCount(tels);
            
            for (int j=0; j<telCount; j++) {
                NSString *tel = ABMultiValueCopyValueAtIndex(tels, j);
                NSString *correctTel = [tel getCorrectMobileNumber];
                //                NSLog(@"name %@ tel %@ mobile %@", fullname, tel, correctTel);
                
                NSString *sectionkey = [NSString stringWithFormat:@"%c", indexTitleOfString([fullname characterAtIndex:0])];
                if ([correctTel isValid]) {
                    NSDictionary *dict = @{@"name":fullname, @"telphone":correctTel, @"sectionkey":sectionkey};
                    [[self.contactDict objectForKey:sectionkey] addObject:dict];
                    
                }
            }
            
        }
        
        [self.sectionArray removeAllObjects];
        
        NSMutableSet *sectionSet = [[[NSMutableSet alloc] init] autorelease];
        [self.contactDict enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSMutableArray *contactArray, BOOL *stop) {
            if (contactArray.count != 0) {
                [sectionSet addObject:key];
            }
        }];
        
        [sectionSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            [self.sectionArray addObject:obj];
        }];
        
        [self.sectionArray sortUsingComparator:^NSComparisonResult(NSString * obj1, NSString * obj2) {
            return [obj1 compare:obj2];
        }];
        
        [self.tableView reloadData];
    }
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
    
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rButton setBackgroundImage:[UIImage imageNamed:@"nav_login_button"] forState:UIControlStateNormal];
    [rButton setBackgroundImage:[UIImage imageNamed:@"nav_login_button_p"] forState:UIControlStateHighlighted];
    [rButton setTitle:@"邀请" forState:UIControlStateNormal];
    [rButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [rButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(inviteFriend) forControlEvents:UIControlEventTouchUpInside];
    rButton.frame = CGRectMake(0, 0, 54, 32);
    UIBarButtonItem *rBarButton = [[[UIBarButtonItem alloc] initWithCustomView:rButton] autorelease];
    self.navigationItem.rightBarButtonItem = rBarButton;
    
    
}

- (void)popVC:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)inviteFriend
{
    MFMessageComposeViewController *controller = [[[MFMessageComposeViewController alloc] init] autorelease];
    controller.body = [self messageBody];
    
    NSMutableArray *tmp = [NSMutableArray array];
    [self.selectArray enumerateObjectsUsingBlock:^(NSDictionary * dict, NSUInteger idx, BOOL *stop) {
        [tmp addObject:[dict objForKey:@"telphone"]];
    }];
    
    controller.recipients = tmp;
    controller.messageComposeDelegate = self;
    [self presentModalViewController:controller animated:YES];
    
}

- (NSString *)messageBody
{
    return @"";
}

#pragma mark - message delegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
            
        case MessageComposeResultCancelled:
            
            NSLog(@"Cancelled");
            
            break;
            
        case MessageComposeResultFailed:
            [kAppDelegate showWithCustomAlertViewWithText:@"发送错误" andImageName:kErrorIcon];
            
            break;
            
        case MessageComposeResultSent:
            
            
            break;
            
        default:
            
            break;
            
    }
    
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.contactDict objForKey:[self.sectionArray objectAtIndex:section]] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionArray objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionArray;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"InviteFriendCell";
    InviteFriendCell *cell = (InviteFriendCell *)[tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InviteFriendCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    NSString *sectionkey = [self.sectionArray objectAtIndex:indexPath.section];
    NSDictionary *dict = [[self.contactDict objectForKey:sectionkey] objectAtIndex:indexPath.row];
    
    if ([self.selectArray containsObject:dict]) {
        cell.selectImage.image = [UIImage imageByName:@"login_select"];
    }
    else{
        cell.selectImage.image = [UIImage imageByName:@"login_noselect"];
    }
    
    cell.nameLabel.text = [dict objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *sectionkey = [self.sectionArray objectAtIndex:indexPath.section];
    NSDictionary *dict = [[self.contactDict objectForKey:sectionkey] objectAtIndex:indexPath.row];
    if ([self.selectArray containsObject:dict]) {
        [self.selectArray removeObject:dict];
    }
    else{
        
        if ([self selectToMax]) {
            [kAppDelegate showWithCustomAlertViewWithText:@"最多选择50人" andImageName:kErrorIcon];
            return;
        }
        else{
            [self.selectArray addObject:dict];
        }
    }
    
    [self.tableView reloadData];
}

- (BOOL)selectToMax
{
    if (self.selectArray.count >= self.selectMax)
    {
        return YES;
    }
    return NO;
}


@end
