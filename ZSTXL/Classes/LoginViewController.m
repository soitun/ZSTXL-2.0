//
//  LoginViewController.m
//  ZXCXBlyt
//
//  Created by zly on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegistViewController.h"
#import "CustomAlertView.h"
#import "UserDetail.h"
#import "CityInfo.h"
#import "MyInfo.h"
#import "Pharmacology.h"
#import "AddInfoViewController.h"
#import <AddressBook/AddressBook.h>

@interface LoginViewController ()

- (void)uploadAddressBook;

@end

@implementation LoginViewController
@synthesize mTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登录";
    }
    return self;
}

- (void)registSucceedAction {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setHidesBottomBarWhenPushed:YES];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registSucceedAction) name:kRegistSucceed object:nil];
    self.view.backgroundColor = bgGreyColor;
    self.mTableView.backgroundColor = bgGreyColor;
    [Utility addShadow:self.navigationController.navigationBar];
    
    
    //back button
    self.backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBarButton setImage:[UIImage imageNamed:@"retreat.png"] forState:UIControlStateNormal];
    [self.backBarButton addTarget:self action:@selector(backToRootVC:) forControlEvents:UIControlEventTouchUpInside];
    self.backBarButton.frame = CGRectMake(0, 0, 30, 30);
    
    UIBarButtonItem *lBarButton = [[[UIBarButtonItem alloc] initWithCustomView:self.backBarButton] autorelease];
    [self.navigationItem setLeftBarButtonItem:lBarButton];
    
    [self.loginButton setImage:[UIImage imageNamed:@"login"] forState:UIControlStateNormal];
    [self.loginButton setImage:[UIImage imageNamed:@"login_p"] forState:UIControlStateHighlighted];
    [self.loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *loginLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 132, 46)] autorelease];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.text = @"登 录";
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginButton addSubview:loginLabel];
    
    [self.registButton setImage:[UIImage imageNamed:@"l_regist"] forState:UIControlStateNormal];
    [self.registButton setImage:[UIImage imageNamed:@"l_regsti_p"] forState:UIControlStateHighlighted];
    [self.registButton addTarget:self action:@selector(registAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *registLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 132, 46)] autorelease];
    registLabel.backgroundColor = [UIColor clearColor];
    registLabel.text = @"注 册";
    registLabel.textColor = [UIColor whiteColor];
    registLabel.textAlignment = NSTextAlignmentCenter;
    [self.registButton addSubview:registLabel];
    
}

- (void)backToRootVC:(UIButton *)sender
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setMTableView:nil];
    [self setLoginButton:nil];
    [self setRegistButton:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRegistSucceed object:nil];
    [mTableView release];
    [_loginButton release];
    [_registButton release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)configureCell:(ELCTextfieldCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        userName = cell.rightTextField;
        cell.leftLabel.text = @"用户名";
        cell.rightTextField.placeholder = @"宝通号或手机号";
    } 
    
    if (indexPath.row == 1) {
        password = cell.rightTextField;
        cell.leftLabel.text = @"密码";
        cell.rightTextField.placeholder = @"密码";
        cell.rightTextField.secureTextEntry = YES;
    }
    cell.isEditable = YES;
    cell.indexPath = indexPath;
    cell.ELCDelegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"ELCCell";
    ELCTextfieldCell *cell = (ELCTextfieldCell *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[[ELCTextfieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    if (indexPath.row == 0) {
//        [cell.rightTextField becomeFirstResponder];
    }
            
    return cell;
}

- (void)loginAction:(UIButton *)sender {
    
    NSString *name = [userName.text removeSpace];
    if (![name isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" 
                                                        message:@"请输入有效的用户名" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"知道了" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    NSString *pwd = [password.text removeSpace];
    if (![pwd isValid]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" 
                                                        message:@"请输入有效的密码" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"知道了" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登录";
    [userName resignFirstResponder];
    [password resignFirstResponder];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"zslogin.json", @"path",
                                                                    name, @"commusername",
                                                                    pwd, @"passwd",
                                                                    kAppDelegate.uuid, @"uuid", nil];
    
    
    NSLog(@"login dict: %@", dict);
    
    [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
        if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            
            self.userid = [[json objForKey:@"Userid"] stringValue];
            [PersistenceHelper setData:self.userid forKey:kUserId];
            [self backToRootVC:nil];
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [kAppDelegate showWithCustomAlertViewWithText:GET_RETURNMESSAGE(json) andImageName:nil];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
    }];
}

- (void)getMyInfo:(MyInfo *)myInfo
{
    
    NSDictionary *getMyInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getMypageDetail.json", @"path", self.userid, @"userid", nil];
    [DreamFactoryClient getWithURLParameters:getMyInfoDict success:^(NSDictionary *myInfoJson) {
        //                NSLog(@"myinfojson %@", myInfoJson);
        if ([[[myInfoJson objectForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
            myInfo.account = [myInfoJson objForKey:@"Account"];
            
            NSDictionary *userDetailDict = [myInfoJson objForKey:@"UserDetail"];
            //                    NSLog(@"user detail dict %@", userDetailDict);
            
            
            UserDetail *userDetail = [UserDetail createEntity];
            userDetail.autograph = [userDetailDict objForKey:@"autograph"];
            userDetail.col1 = [userDetailDict objForKey:@"col1"];
            userDetail.col2 = [userDetailDict objForKey:@"col2"];
            userDetail.col3 = [userDetailDict objForKey:@"col3"];
            userDetail.userid = [[userDetailDict objForKey:@"id"] stringValue];
            userDetail.invagency = [[userDetailDict objForKey:@"invagency"] stringValue];
            userDetail.mailbox = [userDetailDict objForKey:@"mailbox"];
            userDetail.picturelinkurl = [userDetailDict objForKey:@"picturelinkurl"];
            userDetail.remark = [userDetailDict objForKey:@"remark"];
            userDetail.tel = [userDetailDict objForKey:@"tel"];
            userDetail.type = [[userDetailDict objForKey:@"type"] stringValue];
            userDetail.username = [userDetailDict objForKey:@"username"];
            
            myInfo.userDetail = userDetail;
            
            NSArray *areaList = [myInfoJson objForKey:@"AreaList"];
            NSMutableSet *areaSet = [[NSMutableSet alloc] init];
            [areaList enumerateObjectsUsingBlock:^(NSDictionary *cityDict, NSUInteger idx, BOOL *stop) {
                
                CityInfo *city = [CityInfo createEntity];
                [city setValuesForKeysWithDictionary:cityDict];
                [areaSet addObject:city];
            }];
            
            
            
            [myInfo addAreaList:areaSet];
            //                    NSLog(@"myinfo arealist %@", myInfo.areaList);
            
            NSArray *preferList = [myInfoJson objForKey:@"PreferList"];
            NSMutableSet *preferSet = [[NSMutableSet alloc] init];
            [preferList enumerateObjectsUsingBlock:^(NSDictionary *prefer, NSUInteger idx, BOOL *stop) {
                Pharmacology *phar = [Pharmacology createEntity];
                phar.content = [prefer objForKey:@"prefername"];
                phar.pharid = [[prefer objForKey:@"id"] stringValue];
                [preferSet addObject:phar];
            }];
            
            [myInfo addPharList:preferSet];
            [PersistenceHelper setData:userDetail.userid forKey:KUserName];
            [PersistenceHelper setData:password.text forKey:KPassWord];
            
            DB_SAVE();
            
            [self backToRootVC:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginNotification object:nil];
            
            [self uploadAddressBook];
        }
        
    } failure:^(NSError *myInfoError) {
        NSLog(@"error %@", myInfoError);
    }];
}

#pragma mark - login finished method

- (void)uploadAddressBook
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
        NSMutableArray *addressArray = [NSMutableArray array];
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
                if ([correctTel isValid]) {
                    NSDictionary *dict = @{@"name":fullname, @"telphone":correctTel};
                    [addressArray addObject:dict];
                }
            }
        }
        
        [jsonDict setObject:addressArray forKey:@"titlelist"];
        
        NSString *jsonString = [jsonDict JSONString];
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *paraDict = @{@"path": @"addcontacts.json", @"jsondata": jsonString};

        [MBProgressHUD showHUDAddedTo:kAppDelegate.window animated:YES];
        [DreamFactoryClient postWithParameters:paraDict data:jsonData successBlock:^(id obj) {
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
//            NSLog(@"obj %@", obj);
            DLog(@"obj %@", obj);

        } failure:^{
            [MBProgressHUD hideAllHUDsForView:kAppDelegate.window animated:YES];
        }];
    }
}

- (AFJSONRequestOperation *)getUserDetailOp
{
    NSDictionary *getMyInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"getMypageDetail.json", @"path", self.userid, @"userid", nil];
    NSURL *url = [NSURL URLWithString:[self getUrlWithPara:getMyInfoDict]];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:[NSMutableURLRequest requestWithURL:url] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"get User Detai succeed");
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
    }];
    return op;
}

- (NSString *)getUrlWithPara:(NSDictionary *)paraDict
{
    NSMutableString *baseUrl = [NSMutableString stringWithFormat:@"http://www.boracloud.com:9101/BLZTCloud/%@?", [paraDict objectForKey:@"path"]];
    [paraDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSString *paraPair = [NSString stringWithFormat:@"%@=%@&", key, obj];
        [baseUrl appendFormat:@"%@", paraPair];
    }];
    baseUrl = [NSMutableString stringWithString:[baseUrl substringToIndex:baseUrl.length-1]];
    return baseUrl;
}

- (void)registAction:(UIButton *)sender {
    RegistViewController *regist = [[[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:regist animated:YES];
}

- (IBAction)forgotPasswordAction:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"忘记密码提示"
                                                    message:@"请电话联系客服:010-84641808或登录宝来药通官网(www.baolaitong.com)进行修改"
                                                   delegate:nil 
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"知道了", nil];
    [alert show];
    [alert release];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"确认"]) {
        NSString *text = [((CustomAlertView *)alertView).textField.text removeSpace];
        if ([text isValid]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText = @"正在发送请求";

            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"getPass.json", @"path", text, @"commusername", nil];
            [DreamFactoryClient getWithURLParameters:dict success:^(NSDictionary *json) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([[[json objForKey:@"returnCode"] stringValue] isEqualToString:@"0"]) {
                    [kAppDelegate showWithCustomAlertViewWithText:@"密码激活联接已发送至您的邮箱中，请查收" andImageName:nil];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [kAppDelegate showWithCustomAlertViewWithText:kNetworkError andImageName:kErrorIcon];
            }];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" message:@"您输入的用户名或者宝通号不合法，请重新输入" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
            alert.tag = 200;
            [alert show];
            [alert release];
        }
    }
}

@end
